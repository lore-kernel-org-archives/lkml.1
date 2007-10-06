Return-Path: <linux-kernel-owner+w=401wt.eu-S1765263AbXJFUBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765263AbXJFUBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 16:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXJFUBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 16:01:24 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47657 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762657AbXJFUBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 16:01:23 -0400
Date: Sat, 6 Oct 2007 22:01:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bill Davidsen <davidsen@tmr.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <4707E7C9.8010501@tmr.com>
Message-ID: <Pine.LNX.4.64.0710062158190.20637@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
 <4707E7C9.8010501@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6 2007 15:53, Bill Davidsen wrote:
> Jan Engelhardt wrote:
>> Colored kernel message output
>> 
>> Let's work more on Linux's cuteness! [http://lkml.org/lkml/2007/10/4/431]
>> The following patch makes it possible to give kernel messages a
>> selectable color which helps to distinguish it from other noise,
>> such as boot messages. NetBSD has it, OpenBSD has it, FreeBSD to some
>> extent, so I think Linux should too.
>> 
>> Inspired by cko (http://freshmeat.net/p/cko/), but independently
>> written, later contributed forth and back.
>> 
> I like it, although having a boot option would be nice (I have a friend with
> color perception issues).

sysfs attributes can be set at boot time (and not only that).
Here, try the "davej's salad" configuration :-)

	vt.default_red=0,192,128,170,0,170
	vt.default_grn=0,0,170,128,64,0
	vt.default_blu=0,0,0,0,128,128
	vt.printk_color=1,1,1,1,5,3,2

> I start my root xterm in white on blue for identification, so color coding
> sounds like a great idea to me.

This has nothing to do with xterms, this is "VGA color console" only.
xterm config is in /usr/share/X11/app-defaults/XTerm-color.
