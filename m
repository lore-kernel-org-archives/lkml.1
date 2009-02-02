Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZBBL1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZBBL1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZBBL1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:27:31 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:41230 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbZBBL1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:27:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=URtaMpqRoOi/QaPFfgZHCUPw8odp8jyplzpeDk8zoccYKuRcN34kxT5ifx6cxGH/wn
         mzTs5fng5rXrnXOW+VFoMjFl0mP5zrisuxlpGu6wfCnQHqQQMvCcWfFiAk3+B6w5aQqE
         ouJePopjRHj2Av6fD8hDSKKnqoYP2qix0JN+c=
MIME-Version: 1.0
Date: Mon, 2 Feb 2009 14:27:28 +0300
Message-ID: <a4423d670902020327x61a1d9dehb1642b25ec7f82f1@mail.gmail.com>
Subject: next-20090202: task kmemleak:763 blocked for more than 120 seconds.
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It seems it is blocked forever.

[ 1704.619898] INFO: task kmemleak:763 blocked for more than 120 seconds.
[ 1704.697951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1704.791613] kmemleak      D 0000000000000001  6008   763      2
[ 1704.862460]  ffff88007d497e60 0000000000000046 ffff88007d497da0
ffff88007d6a4000
[ 1704.951037]  ffff88007d6a4000 0000000000004000 0000000000000002
ffff88007d6a4000
[ 1705.039609]  ffff88007d80a000 ffff88007d6a4398 0000000200000000
00000001000758b5
[ 1705.128202] Call Trace:
[ 1705.157383]  [<ffffffff806379f2>] ? _spin_unlock_irqrestore+0x42/0x80
[ 1705.234396]  [<ffffffff80634c86>] ? schedule_timeout+0x66/0xe0
[ 1705.304137]  [<ffffffff80634a43>] schedule+0x13/0x40
[ 1705.363483]  [<ffffffff80634c86>] schedule_timeout+0x66/0xe0
[ 1705.431145]  [<ffffffff8024c7c0>] ? process_timeout+0x0/0x10
[ 1705.498918]  [<ffffffff80634c81>] ? schedule_timeout+0x61/0xe0
[ 1705.568663]  [<ffffffff80634d19>] schedule_timeout_uninterruptible+0x19/0x20
[ 1705.652987]  [<ffffffff802c3830>] kmemleak_scan_thread+0x120/0x170
[ 1705.726889]  [<ffffffff802c3710>] ? kmemleak_scan_thread+0x0/0x170
[ 1705.800784]  [<ffffffff80258d66>] kthread+0x56/0x90
[ 1705.859088]  [<ffffffff8020ce9a>] child_rip+0xa/0x20
[ 1705.918441]  [<ffffffff80235489>] ? finish_task_switch+0x89/0x110
[ 1705.991303]  [<ffffffff80637986>] ? _spin_unlock_irq+0x36/0x60
[ 1706.061041]  [<ffffffff8020c880>] ? restore_args+0x0/0x30
[ 1706.125584]  [<ffffffff80258d10>] ? kthread+0x0/0x90
[ 1706.184917]  [<ffffffff8020ce90>] ? child_rip+0x0/0x20
[ 1706.246334] no locks held by kmemleak/763.
