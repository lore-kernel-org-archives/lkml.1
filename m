Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZGFVRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZGFVRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZGFVRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:17:37 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:38724 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbZGFVRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:17:36 -0400
X-Greylist: delayed 711 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 17:17:36 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200907062105.n66L5mOj008230@clem.clem-digital.net>
Subject: 2.6.31-rc1/rc2 oops tty-layer -- dead network
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Mon, 6 Jul 2009 17:05:48 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi. Got this with rc2 (similiar with rc1) kills ppp, console, and
networking.

BUG: scheduling while atomic: pppoe/1535/0x00000500
Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp xt_tcpudp ipt_REJECT ipt_LOG iptable_filter ip_tables x_tables ipv6

Pid: 1535, comm: pppoe Not tainted (2.6.31-rc2 #1) 
EIP: 0060:[<c1106baf>] EFLAGS: 00000282 CPU: 0
EIP is at tty_ldisc_deref+0x1f/0x60
EAX: 00000000 EBX: c7a4ea80 ECX: 00000001 EDX: 00000000
ESI: 00000282 EDI: 00000000 EBP: 00001000 ESP: c7ae1ed0
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 8005003b CR2: b7fab000 CR3: 07aa8000 CR4: 00000010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c11011e7>] ? tty_wakeup+0x47/0x50
 [<c1107d32>] ? pty_unthrottle+0x12/0x30
 [<c11055cc>] ? tty_unthrottle+0x2c/0x40
 [<c1103c57>] ? n_tty_read+0x4b7/0x720
 [<c1012190>] ? default_wake_function+0x0/0x10
 [<c10fff0a>] ? tty_read+0x6a/0xa0
 [<c11037a0>] ? n_tty_read+0x0/0x720
 [<c10ffea0>] ? tty_read+0x0/0xa0
 [<c1059cd0>] ? vfs_read+0x80/0x100
 [<c1059dfc>] ? sys_read+0x3c/0x70
 [<c1002a85>] ? syscall_call+0x7/0xb

-- 
Pete Clements 
