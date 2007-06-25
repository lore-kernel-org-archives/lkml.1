Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbXFYALy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbXFYALy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXFYALr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:11:47 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1465 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbXFYALq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:11:46 -0400
Date: Mon, 25 Jun 2007 02:11:46 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, toralf.foerster@gmx.de,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <Pine.LNX.4.64.0706230855180.26568@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0706250110430.1817@scrub.home>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net> 
 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com> 
 <Pine.LNX.4.64.0706222336210.1817@scrub.home> 
 <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com> 
 <Pine.LNX.4.64.0706230017430.1817@scrub.home> 
 <a781481a0706221533j34c341c5gf7ff92997e2463a6@mail.gmail.com> 
 <Pine.LNX.4.64.0706230049480.1817@scrub.home> 
 <a781481a0706221626q17f533ccnac09b2cc7c89126d@mail.gmail.com> 
 <Pine.LNX.4.64.0706230137090.1817@scrub.home>
 <a781481a0706221649j19f9ce2apcf295ddf9530da1e@mail.gmail.com>
 <Pine.LNX.4.64.0706230216140.1817@scrub.home>
 <Pine.LNX.4.64.0706230855180.26568@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 23 Jun 2007, Jan Engelhardt wrote:

> Would it make sense to define a new entity called "configmenu" (or something
> else) that is equivalent to menuconfig with the following changes?
> 
>  * it creates a CM_ variable instead of a CONFIG_ one
>  * the CM_ symbols are not available to Makefiles or C files
>    (so in fact, just to menuconfig and that they are listed in .config)

I really don't understand why this should be needed in first place.
Where is the problem with using tristate? Nobody forces anyone to set it 
to 'm' if you don't like it. I could also argue it easily allows me to 
quickly restrict enclosed options to module status. It's just another 
choice, where is that fascination coming from that it has to be an on/off 
switch?
Whether the config option is visible in the Makefile and produces any 
code, is completely irrelevant in this context, as the user trying to 
configure the kernel has no idea of it.

bye, Roman
