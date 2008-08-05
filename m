Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYHEOql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYHEOql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYHEOqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:46:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60379 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYHEOq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=dFtuCYrm9AYXiJrBZCa/Zt6qC2hGLrUV4oMZkK0q4Pcgrn9AJIc8SZDKmqc+rgAWkC
         X20L+IlJLxe/Fp+Bt/wkr5i8S+p+BqPs1FNLxw5I8jRUwsQ+HLjRhLCeNrpy8/gmCTwN
         T0bVJrAi9+R5BXp894O/WNwhUqohw4cgspJbk=
Message-ID: <3f9a31f40808050746r1b35799am8bf0e4a637069fa@mail.gmail.com>
Date: Tue, 5 Aug 2008 20:16:28 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: BUG: fealnx in 2.6.27-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eth0: no IPv6 routers present
NETDEV WATCHDOG: eth0 (fealnx): transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring f7b56000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring f7b57000:  0000 80000000 80000000 80000000 80000000 80000000
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:221 dev_watchdog+0x109/0x181()
Modules linked in:
Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.27-rc1 #109
 [<c011c26a>] warn_on_slowpath+0x40/0x63
 [<c0132f1a>] tick_program_event+0x2b/0x4a
 [<c012df6e>] hrtimer_interrupt+0x13a/0x162
 [<c010f291>] smp_apic_timer_interrupt+0x6c/0x76
 [<c010359c>] apic_timer_interrupt+0x28/0x30
 [<c03ab466>] _spin_unlock_irqrestore+0x4/0x1a
 [<c02720f1>] tx_timeout+0x189/0x1c5
 [<c032b306>] dev_watchdog+0x109/0x181
 [<c01235c0>] __mod_timer+0x8e/0x97
 [<c03264cc>] neigh_periodic_timer+0x14a/0x158
 [<c032b1fd>] dev_watchdog+0x0/0x181
 [<c01230e2>] run_timer_softirq+0x123/0x17b
 [<c011fff9>] __do_softirq+0x6f/0xd2
 [<c012008e>] do_softirq+0x32/0x36
 [<c0120109>] ksoftirqd+0x77/0x128
 [<c0120092>] ksoftirqd+0x0/0x128
 [<c012af79>] kthread+0x38/0x5d
 [<c012af41>] kthread+0x0/0x5d
 [<c01036df>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 090ebc3b866eecff ]---
