Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZCGHjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZCGHjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 02:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZCGHjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 02:39:12 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53573 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZCGHjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 02:39:11 -0500
To: eparis@parisplace.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.29-rc7: MPT: ODEBUG: object is on stack, but not annotated
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200903071639.CCC04687.FOMVQOFLFHJOtS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 7 Mar 2009 16:39:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

2.6.29-rc7 forgot to apply a patch for MPT's
"ODEBUG: object is on stack, but not annotated" warning?

[    4.856441] Fusion MPT SPI Host driver 3.04.07
[    4.857263] mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.858263] kmmio: spurious debug trap on CPU 1.
[    4.858678] mptbase: ioc0: Initiating bringup
[    4.877967] ioc0: LSI53C1030 B0: Capabilities={Initiator}
[    4.911434] ODEBUG: object is on stack, but not annotated
[    4.911450] ------------[ cut here ]------------
[    4.911466] WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2d1/0x338()
[    4.911481] Hardware name: VMware Virtual Platform
[    4.911497] Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi ext3 jbd mbcache
[    4.911513] Pid: 566, comm: insmod Not tainted 2.6.29-rc7 #1
[    4.911528] Call Trace:

Regards.
