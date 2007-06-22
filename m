Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbXFVVpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbXFVVpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXFVVpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:45:31 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2924 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXFVVpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:45:30 -0400
Date: Fri, 22 Jun 2007 23:45:24 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       linux-usb-devel@lists.sourceforge.net, toralf.foerster@gmx.de,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706222336210.1817@scrub.home>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de>  <1182518566.14289.20.camel@gaivota>
  <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 23 Jun 2007, Satyam Sharma wrote:

> given "menuconfig FOO depends on BAR", then all the "config BAZ"s
> inside this menuconfig also automatically "depend on" BAR too.
> This is simpler in the long run because it requires least amount
> (actually none) of redundant typing

I don't like this, as this would attach special meaning to a menuconfig. 
menuconfig is really a type of config symbol, rather than a type of menu.
Potentially this could also be written as:

config FOO
	option menu
	...

bye, Roman
