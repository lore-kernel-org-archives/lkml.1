Return-Path: <linux-kernel-owner+w=401wt.eu-S1423026AbXBPCAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423026AbXBPCAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 21:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423025AbXBPCAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 21:00:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:18665 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423026AbXBPCAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 21:00:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kzg9KvvujNnh2Y8X3Qe7eZY4YJuocdRCEmj1eIdIacvpaCBQk1ySnRmAodKmxmJ0nIPyt4+6Fl6OhbADfiCofs7MFnxivZcDxTqLd4HvpDnZHmifAVBoPJtyykdA2IVhSgYlezhHe0FrvVf6NbSs4L3txjPJP1l8syKx79TXI20=
Message-ID: <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
Date: Thu, 15 Feb 2007 18:00:36 -0800
From: "v j" <vj.linux@gmail.com>
To: "Scott Preece" <sepreece@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <7b69d1470702151705h297c3b38g138eb0138b900aea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <7b69d1470702151705h297c3b38g138eb0138b900aea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Scott Preece <sepreece@gmail.com> wrote:
> On 2/15/07, v j <vj.linux@gmail.com> wrote:
> > So far I have heard nothing but, "if you don't contribute, screw you."
> > All this is fine. Just say so. Make it black and white. Make it
> > perfectly clear what is and isn't legal. If we can't load proprietary
> > modules, then so be it. It will help everybody if this is out in the
> > clear, instead of resorting to stupid half measures like
> > EXPORT_SYMBOL_GPL.
> ---
>
> I'm not sure what you're asking for. Greg KH's statement was pretty
> black-and-white, and there are a lot of comments in this stream, from
> name-brand developers, that are in line with them. They're the best
> answer you can hope for on this question. The question you're asking
> is an issue of interpretation, which only a court can answer. Do you
> want them to modify the license to make this particular issue clearer?
> Or do you just want a statement from Linus?

Which statement are you talking about? First of all it is not clear to
me if proprietary modules need to be GPL or not. If they do, I guess I
have nothing to say. If that is the way developers want it, so be it.

Assuming these need not be GPL, I have a problem with
EXPORT_SYMBOL_GPL and the general trend in the direction of making
proprietary drivers harder on companies. Our drivers use basic
interfaces in the kernel like open, read, write, ioctl, semaphores,
interrupts, timers etc. This is functionality we would expect from any
operating system. We used devfs before and had no problems there. Greg
KH has gone and made the basic sysfs interface, which any generic
driver could use as EXPORT_SYMBOL_GPL. I don't really care, I just
don't use sysfs. The point is that old functionality is being ripped
off and new ones introduced, and their interfaces are not open
anymore. Hence there will be a point where non-GPLed drivers simply
cannot be loaded.

So why beat about the bush? Just make it illegal to load proprietary
drivers, or remove EXPORT_SYMBOL_GPL.

vj.
