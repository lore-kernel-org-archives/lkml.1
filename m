Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbXFVWLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbXFVWLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbXFVWLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:11:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:23470 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbXFVWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:11:39 -0400
Date: Sat, 23 Jun 2007 00:11:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       linux-usb-devel@lists.sourceforge.net, toralf.foerster@gmx.de,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706230010330.26568@fbirervta.pbzchgretzou.qr>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de>  <1182518566.14289.20.camel@gaivota>
  <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 23 2007 02:50, Satyam Sharma wrote:
>
> Ok, so we add this as solution 2.(c) to the reply I just sent to Jan :-)
>
> But I still prefer 2.(b) -- making the config scripts intelligent so that if a
> given "menuconfig FOO depends on BAR", then all the "config BAZ"s
> inside this menuconfig also automatically "depend on" BAR too.
> This is simpler in the long run because it requires least amount
> (actually none) of redundant typing and would continue to work in
> the future if/when the:
>
> menuconfig FOO
> if FOO
> ...
> endif # FOO
>
> idiom is converted to an:
>
> configmenu FOO
> ...
> endconfigmenu # FOO
>
> kind of idiom ...

Of course *this* *is* *the preferred* thing. (I think even Sam liked that one
better than the current menuconfig menuconfig confusion.) But, as always, you
need someone to code it, etc.


	Jan
-- 
