Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXLOMOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXLOMOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 07:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbXLOMOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 07:14:35 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:38272 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbXLOMOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 07:14:34 -0500
Date: Sat, 15 Dec 2007 14:14:31 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: PPC: sysctl table check failed
Message-ID: <Pine.SOC.4.64.0712151412550.14950@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried todays 2.6.24-rc5+git on ppc architecture (PReP subarch). Seems to 
work as well as before but got this call trace on boot:

sysctl table check failed: /kernel/l2cr .1.31 Missing strategy
Call Trace:
[cfc21df0] [c000c4e8] show_stack+0x58/0x1d0 (unreliable)
[cfc21e30] [c003c540] set_fail+0x50/0x80
[cfc21e50] [c003c998] sysctl_check_table+0x428/0x730
[cfc21ec0] [c003c9a8] sysctl_check_table+0x438/0x730
[cfc21f30] [c00260c8] register_sysctl_table+0x68/0xd0
[cfc21f50] [c02fa938] register_ppc_htab_sysctl+0x18/0x30
[cfc21f60] [c02f9268] kernel_init+0xd8/0x2e0
[cfc21ff0] [c0006338] kernel_thread+0x44/0x60


-- 
Meelis Roos (mroos@linux.ee)
