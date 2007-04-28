Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbXD1K7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbXD1K7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965780AbXD1K7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:59:43 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57657 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965778AbXD1K7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:59:42 -0400
Date: Sat, 28 Apr 2007 12:57:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/30] Use menuconfig objects - IEEE1394
In-Reply-To: <463324CD.1010604@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0704281254280.506@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr> <4632638D.2050004@s5r6.in-berlin.de>
 <Pine.LNX.4.61.0704280944100.506@yvahk01.tjqt.qr> <463324CD.1010604@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 28 2007 12:41, Stefan Richter wrote:
>
>So, shall I put Jan's patch aside until there is only one stack left?

Sort of.

>Or what about:
>
>	menuconfig FIREWIRE_SUPPORT
>		tristate "IEEE 1394 (FireWire) support"
>
>	config FIREWIRE
>		tristate "new FireWire stack, alias Juju"
>		depends on FIREWIRE_SUPPORT && !(IEEE1394=y)
>		default m
>	[...]
>
>	config IEEE1394
>		tristate "legacy FireWire stack"
>		depends on FIREWIRE_SUPPORT && !(FIREWIRE=y)

Would
&& FIREWIRE != y
work?

>		default m
>	[...]
>
>	comment "You can have both stacks installed but should blacklist
>	         the modules of one of them.  Else modules from both
>	         stacks will be autoloaded on hotplug events."
>		depends on FIREWIRE && IEEE1394

If you *really* want to do that, then have it. But when a menu has
two or three choices (in this case: larger subsystems), it's rand()
for me whether or not to convert to menuconfig.
Feel free.



Jan
-- 
