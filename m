Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbXHATGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbXHATGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbXHATGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:06:12 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:3897 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757593AbXHATGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:06:11 -0400
Message-ID: <46B0D997.8030805@interia.pl>
Date: Wed, 01 Aug 2007 21:05:59 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Problem with udev and block2mtd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 3fdb6acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have changed static /dev to udev on my machine. It has 
a lot of RAM (94MB) so I was expecting that udev will not make 
things worse. Unfortunately udev isn't noticing that new mtd 
device was born. I was suspecting that this is my fault, but 
udev's /dev is populated and:
UEVENT[1185991604.930847] add@/module/mtdcore
UEVENT[1185991604.969089] add@/module/mtdpart
UEVENT[1185991605.005954] add@/module/block2mtd
UEVENT[1185991647.726551] add@/module/mtdsuper
UEVENT[1185991647.783396] add@/module/jffs2
UEVENT[1185991647.801242] add@/slab/jffs2_i
UDEV  [1185991647.815670] add@/slab/jffs2_i
UEVENT[1185991647.827608] add@/slab/:0000072
UDEV  [1185991647.842338] add@/slab/:0000072
I don't see nothing about new device.

Is this situation known? Or this is 2.6.23-rc1-git3 regression? 
Or is my udev misconfigured?

Regards
Rafał

----------------------------------------------------------------------
Wszystko czego potrzebujesz latem: kremy do opalania, 
stroje kapielowe, maly romans 

>>>http://link.interia.pl/f1b15

