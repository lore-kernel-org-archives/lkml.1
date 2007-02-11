Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbXBKDeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbXBKDeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 22:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXBKDeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 22:34:20 -0500
Received: from mail.nagafix.co.uk ([194.145.196.85]:43802 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXBKDeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 22:34:19 -0500
Message-ID: <45CE8D74.6030700@nagafix.co.uk>
Date: Sun, 11 Feb 2007 03:28:52 +0000
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org
Subject: reporting lost ticks
References: <45C4EBA8.8080704@nagafix.co.uk> <20070205130807.GA46862@muc.de>
In-Reply-To: <20070205130807.GA46862@muc.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> [Snip]
> You run with report_lost_ticks and report the results to linux-kernel

Doing as I am told, here we go:
This is 100% reproducible, ie: just doing a big rsync between 2 disks 
and burning a DVD at the same time. Note: the system isn't very 
responsive when this happens, most notably: audio seems to jump every 
~1second.
Hardware is an ASUS K8N-DL with a pair of Opteron 270s, 4GB PC3200, SATA 
  disks, software raid.

time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip __do_softirq+0x44/0xc0)
time.c: Lost 6 timer tick(s)! rip _spin_unlock_irq+0x10/0x40)

You can find a much longer version of the kernel output here:
http://194.145.196.85/ticks
http://194.145.196.85/ticks2
If you need anything else just let me know.

Antoine
