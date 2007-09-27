Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbXI0VB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbXI0VB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXI0VBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:01:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:27897 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbXI0VBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fICYoJnZIgYZIDKvFATpDI5hFKewmS3KxzXXfg+JltsGt4BGnAxSjtrqhz+1PhqBiyl4SMLxyXZ+zu9QQ1+XUO7CoAYojMrPPQSQj3NLJqit29zwyMQEgIj4x5ycTr5F31k43FpzFsThITdW8afVv9YM43t/wiWf/pOLlPmBsq8=
Message-ID: <a6a840cd0709271401r56d5bebes8e361994ecc5746a@mail.gmail.com>
Date: Fri, 28 Sep 2007 00:01:18 +0300
From: "Dmitry Tyschenko" <dtyschenko@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: NO_HZ hangs up AMD MK-36
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200709272259.26412.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a6a840cd0709271328p76ee6a22tf3b60678d6a2d455@mail.gmail.com>
	 <200709272259.26412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I am newbie in linux. Hope you was talking about:
/boot/vmlinuz-2.6.22-1-k7 root=/dev/sda5 ro nohz=off
But it doesn't help for Debians 2.6.22-1 (I don't have another
prebuiled) still same problems.

2007/9/27, Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, 27 September 2007 22:28, Dmitry Tyschenko wrote:
> > Hello,
> >
> > I have laptop Asus X50M. Using old Debian Etch from February.
> > Kernel from 2.6.21 doesn't boot, hangs up just in 10seconds -  1minute
> > after GRUB screen.
> > I have tryed different versions of gcc (4.1.1, 4.1.2, 4.2.1) to build
> > 2.6.22.8 kernel, but no results.
> > But if I disable NO_HZ option 2.6.21 is working fine for me.
> >
> > I think this is important problem, because some of the project, Debian
> > for example,
> >  are building kernel with this options enabled (in
> > linux-image-2.6.22-1-k7 package it is enabled),
> > and some people, like me, can not use new kernels.
> >
> > I have attached some of my PC info, hope this can help
>
> You can use the "nohz=off" kernel command line switch.  Please check if it
> works for you.
>
> Greetings,
> Rafael
>
