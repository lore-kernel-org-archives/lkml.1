Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbXJKE7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbXJKE7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 00:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbXJKE7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 00:59:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:21370 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbXJKE7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 00:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C4JbIguFu1t5lGbX+kxQcJyDn4VT5Ur4wWJ/oF1UCQmepv2+TijIwdPt7AdCZS6J9q/dKhfsE+XJRs9hf6LNd8CcB0D6CY72j57TYFQMnoAxphB468AYo0vYvlJoEvj5fCqTjx6KaQGC4R0Rgmf80EyKXiGxTYDnrEnSifqABi4=
Message-ID: <d9def9db0710102159q2e5f9dadr341b409285f262e0@mail.gmail.com>
Date: Thu, 11 Oct 2007 06:59:17 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <470D61CF.3070307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <d9def9db0710101624t5e0a3523p12c367dc1d414349@mail.gmail.com>
	 <470D61CF.3070307@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 10/10/2007 07:24 PM, Markus Rechberger wrote:
> >
> > To point to more changes within the available driver which hasn't been
> merged
> > within the last 1 1/2 years:
> > * it supports non usbaudio based video devices.
> > * has support for dvb-t/atsc
> > * allows multiple device node access in case of analogue TV
> > * has teletext/VBI support for PAL.
> > * it supports modules which are now in userspace instead of
> > kernelspace due disagreements with some developers for 1 1/2 years.
> > * I do not agree with certain developers who do not have any experience
> > with certain parts of the code for redoing it a 4th time now. My patience
> > is over, which includes the company support in my back to get those
> > devices supported.
> >
>
> Do you plan on maintaining your own private driver tree for all of eternity?
>

I plan to tidy it up for inclusion and put everything together to get
it work properly.
The code which is in the kernel is around 5 % done, the code which is
available on mcentral.de is around 50% done. It still requires some
work to get _all_ devices supported, and keeping the development
process in an endless loop and depending on people who have no idea
and don't care about certain requirements is no option.
The upcoming devices which use other chips and which have more
features will at least also use those drivers. I expect that it will
pump up the driver to support more than 100 devices within the next
year.

Markus
