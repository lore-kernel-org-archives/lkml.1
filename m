Return-Path: <linux-kernel-owner+w=401wt.eu-S1763725AbYDTKxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763725AbYDTKxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763210AbYDTKtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:49:19 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:54940 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761939AbYDTKtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:49:17 -0400
X-Greylist: delayed 1000 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 06:49:17 EDT
Message-ID: <480B1BC0.7020208@numericable.fr>
Date: Sun, 20 Apr 2008 12:32:32 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: genapic warning in 2.6.25-git2
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


When upgrading to 2.6.25-git2 kernel, this warning occurs when booting :

[    0.072622] ------------[ cut here ]------------
[    0.072658] WARNING: at arch/x86/kernel/genapic_64.c:86 
read_apic_id+0x56/0x60()
[    0.072698] Modules linked in:
[    0.072764] Pid: 1, comm: swapper Not tainted 2.6.25-git2 #1
[    0.072991]
[    0.072991] Call Trace:
[    0.073062]  [<ffffffff802378ef>] warn_on_slowpath+0x5f/0x80
[    0.073101]  [<ffffffff805fadf8>] ? _spin_lock+0x18/0x20
[    0.073139]  [<ffffffff8085e3f5>] ? set_cpu_sibling_map+0x215/0x390
[    0.073175]  [<ffffffff80221356>] read_apic_id+0x56/0x60
[    0.073213]  [<ffffffff8083c642>] verify_local_APIC+0xb2/0x1a0
[    0.073251]  [<ffffffff8083b48d>] native_smp_prepare_cpus+0x1ad/0x3a0
[    0.073289]  [<ffffffff80832923>] kernel_init+0x53/0x350
[    0.073327]  [<ffffffff805fb189>] ? _spin_unlock_irq+0x9/0x40
[    0.073366]  [<ffffffff80230328>] ? finish_task_switch+0x48/0xc0
[    0.073405]  [<ffffffff8020c4c8>] child_rip+0xa/0x12
[    0.073442]  [<ffffffff808328d0>] ? kernel_init+0x0/0x350
[    0.073478]  [<ffffffff8020c4be>] ? child_rip+0x0/0x12
[    0.073514]
[    0.073554] ---[ end trace ca143223eefdc828 ]---
[    0.073590] ------------[ cut here ]------------

