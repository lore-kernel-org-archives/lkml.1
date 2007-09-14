Return-Path: <linux-kernel-owner+w=401wt.eu-S934223AbXINQS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223AbXINQS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbXINQSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:18:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:58633 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbXINQSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lE189KlfyVNUfa/0UP8EJGtmvLk2sn+mfpvfSv9H5k4qqSECfSoWIBaJCI3ucBrGXMqcUwyrkyL7YPDfe6duqIeHjcK11Aq+aSK5ma177lvD79haumjCZmslQ2rNx/G5vnfNmRd30lv7E4IS4xqVW6P3yluZtikUGWiin0sU8Vc=
Message-ID: <d9def9db0709140918m4eff0fe9if01c3383a3a5c3ce@mail.gmail.com>
Date: Fri, 14 Sep 2007 18:18:00 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alan Cox" <alan@redhat.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Steven Toth" <stoth@hauppauge.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070914135237.GB19311@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C1BCC5.9090709@amd.com>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <20070913131353.GB26972@linuxtv.org>
	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <20070914135237.GB19311@devserv.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Alan Cox <alan@redhat.com> wrote:
> On Fri, Sep 14, 2007 at 01:17:05AM +0200, Markus Rechberger wrote:
> > what stops vendors of using the current existing code to achieve that
> > goal. They could provide binary drivers with the existing API.
>
> If you feel lucky about the GPL
>
> > What stops companies to intercept the ioctl calls and overriding some
> > I2C commands?
>
> The GPL - derivative work is the boundary not code linkage. Possibly a
> userspace
> tuner hack would probably fit this too. Especially if a specific vendor is
> producing both bits together and trying to claim they are independant.
>
> > How about proprietary video formats, would you also place the decoding
> > algorithms in kernel  just to force companies to release their code
> > for it?
>
> No, I would assume they'd provide a proprietary conversion library that
> no nobody would use (just like their hw). We keep format conversion firmly
> seperated from hardware I/O processing.
>

In general there are known formats available, the drawback is that every TV
application deals with it in a non-unified way at the moment, meaning alot
code duplication in userspace since there's no library available at the moment
which does the videoconversion from one to another format. Such a library is
beeing developed at the moment which gets plugged infront of accessing
the devicenodes.

Although in the long run I'm looking forward to reuse the userspace tuners with
such a library infront of everything by using i2c-dev.
This would also make it easy to reuse the sample code of several companies,
without having to cut out several features of the drivers and to rewrite them
to an inkernel format.

Markus
