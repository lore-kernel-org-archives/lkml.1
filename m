Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbXFWG56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbXFWG56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 02:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXFWG5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 02:57:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:21492 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXFWG5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 02:57:50 -0400
Date: Sat, 23 Jun 2007 08:57:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, toralf.foerster@gmx.de,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <Pine.LNX.4.64.0706230216140.1817@scrub.home>
Message-ID: <Pine.LNX.4.64.0706230855180.26568@fbirervta.pbzchgretzou.qr>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 23 2007 02:26, Roman Zippel wrote:
>On Sat, 23 Jun 2007, Satyam Sharma wrote:
>
>> But why? Let it do just one thing, and do it well. Is their
>> any requirement anywhere that requires us to give a dual
>> meaning to these menuconfig objects -- i.e. to also control
>> the inclusion / exclusion of code from the kernel as well as
>> also for the presentation + user interface purpose that it
>> currently serves?
>
>This getting ridiculous. :-(
>You're the one who is attaching a new meaning to it.
>Any config symbol has multiple meanings depending on the context, the menu 
>property only changes _one_ of them, you want to drastically redefine it 
>and that's not going to happen.

Would it make sense to define a new entity called "configmenu" (or something
else) that is equivalent to menuconfig with the following changes?

 * it creates a CM_ variable instead of a CONFIG_ one
 * the CM_ symbols are not available to Makefiles or C files
   (so in fact, just to menuconfig and that they are listed in .config)


	Jan
-- 
