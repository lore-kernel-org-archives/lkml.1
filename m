Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYHBVQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYHBVQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 17:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYHBVQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 17:16:28 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:17055 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYHBVQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 17:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TqWstLUGncPZBN3Xq/9elry0QTdChs9ok6fmuOHTWZ6l/mC7iXP34a9t4qLc//VqNB
         lVrvWpaqUHy+wWCYL6KtV4uTjEPe2wtIPk1jDDhSsVjHW/7OpAaaY2ZGvBPcrz4Cv/E3
         IfDp1zCCWSbQjyFR+f2TwkWl9R800e41ZBwKE=
Message-ID: <520f0cf10808021416n286855f9s126d416230aee249@mail.gmail.com>
Date: Sat, 2 Aug 2008 23:16:25 +0200
From: "John Kacur" <jkacur@gmail.com>
To: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Can't boot 2.6.26-rt1
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFS: Cannot open root device
"disk/by-id/scsi-SATA_WDC_WD1600BEVS-WD-WXEZ07100576-part 7" or
unknown block(0,0)
Please append a correct "root = " boot option; here are the available
partitions.
Pid:1,comm:swapper Not tainted
2.6.26-rt1-default#1linux-rt-users@vger.kernel.org
[< ffff ffff 8046 c149 >] rt_mutex_lock+0x22/0x50
[< ffff ffff 8046 cae6 >] _mutex_unlock+0xe/0x10
[< ffff ffff 8020 cb00 >] exit_intr+0x10/0x1e
[< ffff ffff 8028 633d >] trace_hardirqs_on_caller+0x1e/0x133
[< ffff ffff 8020 d608 >] child_rip+0xa/0x12
[< ffff ffff 8020 cb69 >] restore_args+0x0/0x30
[< ffff ffff 8020 d5fe >] child_rip+0x0/0x12

preempt count 00000001
1-level deep critical section nesting
[< ffff ffff 8047 43e2 >] .... panic +0x43/0x167
[< ffff ffff 8073 6338 >] (<= mount_block_root+0x258/0x26f
