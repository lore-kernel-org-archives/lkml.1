Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZALAs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZALAs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 19:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZALAsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 19:48:19 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:65509 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZALAsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 19:48:18 -0500
Date: Mon, 12 Jan 2009 01:48:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Message-ID: <20090112004816.GA13068@osiris.boeblingen.de.ibm.com>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <8db1092f0901111215m5712caccvc0d2e5e7cb7e8f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db1092f0901111215m5712caccvc0d2e5e7cb7e8f7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 09:15:38PM +0100, Maciej Rutecki wrote:
> 2009/1/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > Hi
> >
> > I've booted and tested 2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)
> >
> > I've observed that suspend is unusable - it goes to sleep - the sleep
> > LED is on. After few secs system turns on back itself - and stays in
> > some frozen state
> 
> A have similar situation, one difference: I get blank screen during
> resume from suspend to ram. Also sometimes, like You, system turns on
> back itself.
> 
> [...]
> 
> > but most probably this is not very helpful - however it's kind of hard
> > to bisect kernel, because patches in the transition from
> > 2.6.28->2.6.29-rc1 usually caused a lot of unstable behavior on my
> > T61.
> 
> The same. Suspend to disk die on this message:
> http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1/pc/img_0002.jpg
> (this is during go to suspend to disk, NOT resume)
> 
> I try bisect, but I got many other problems, like this:
> http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1/pc/img_0003.jpg
> 
> So, I cannot finish bisect.

The bug seen in img_0003.jpg is fixed with

a0e280e0f33f6c859a235fb69a875ed8f3420388

So you could continue bisecting if you would apply the patch, compile
the kernel and test it, and revert the patch again before marking the
kernel good/bad.
