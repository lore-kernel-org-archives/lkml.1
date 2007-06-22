Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbXFVXMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbXFVXMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXFVXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:12:16 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4852 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbXFVXMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:12:15 -0400
Date: Sat, 23 Jun 2007 01:12:29 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, toralf.foerster@gmx.de,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <a781481a0706221533j34c341c5gf7ff92997e2463a6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706230049480.1817@scrub.home>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de>  <1182518566.14289.20.camel@gaivota>
  <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net> 
 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com> 
 <Pine.LNX.4.64.0706222336210.1817@scrub.home> 
 <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com> 
 <Pine.LNX.4.64.0706230017430.1817@scrub.home>
 <a781481a0706221533j34c341c5gf7ff92997e2463a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 23 Jun 2007, Satyam Sharma wrote:

> 1. Kconfig symbols will always have code associated with them.
> That's the entire purpose of Kconfig, is it not?

A possible counter example: CONFIG_SCSI.
(RAID_ATTRS is currently a little misplaced).
It's optional for any config symbol to have any code attached to it, 
menuconfig doesn't change anything.

> 2. "menuconfig" symbols, otoh, were _invented_ for another reason
> entirely: presentation and user interface i.e. so that users are able
> to disable entire menus (and all the options contained therein)
> without having to enter into the menu first, and without having to
> disable all options individually (which was the situation that existed
> before the introduction of these menuconfig objects).

Since I'm the one who _invented_ it, I can tell you you're wrong. :)
This functionality isn't limited to menuconfig symbols. The menu option 
simply changes how the child symbols can be displayed.

bye, Roman
