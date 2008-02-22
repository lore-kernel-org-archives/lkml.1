Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbYBVLHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbYBVLHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYBVLH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:07:28 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:47000 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbYBVLH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:07:27 -0500
X-Greylist: delayed 1581 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 06:07:26 EST
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: lockdep warning
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 22 Feb 2008 11:40:49 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080222104049.BD95A93C12F@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JSVMT-0008Md-7t.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1JSVMT-0008Md-7t f0ed6894877dd97f8b38839c34d583b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found this is a newly booted 2.6.25-rc2's syslog.

Feb 21 20:46:33 tippex BUG: rwlock wrong owner on CPU#0, runscript.sh/2633, d2c04084
Feb 21 20:46:33 tippex Pid: 2633, comm: runscript.sh Not tainted 2.6.25-rc2 #3
Feb 21 20:46:33 tippex [<c02342d0>] rwlock_bug+0x50/0x60
Feb 21 20:46:33 tippex [<c0234356>] _raw_write_unlock+0x56/0x60
Feb 21 20:46:33 tippex [<c040365d>] _write_unlock+0x1d/0x50
Feb 21 20:46:33 tippex [<c03289be>] neigh_timer_handler+0x18e/0x2d0
Feb 21 20:46:33 tippex [<c0125449>] run_timer_softirq+0x119/0x180
Feb 21 20:46:33 tippex [<c013856d>] ? lock_release_holdtime+0x5d/0x80
Feb 21 20:46:33 tippex [<c0328830>] ? neigh_timer_handler+0x0/0x2d0
Feb 21 20:46:33 tippex [<c0121a64>] __do_softirq+0x54/0xb0
Feb 21 20:46:33 tippex [<c0121af5>] do_softirq+0x35/0x40
Feb 21 20:46:33 tippex [<c0121cb4>] irq_exit+0x44/0x50
Feb 21 20:46:33 tippex [<c0105757>] do_IRQ+0x47/0x80
Feb 21 20:46:33 tippex [<c01039c3>] common_interrupt+0x23/0x28
Feb 21 20:46:33 tippex =======================


It doesn't make any sens to me but I guess it does to others.

The other bad thing is that the machine hangs shortly after boot bitching 
about 'hdb: lost interrupt' on the console. Kown problem?

/A

