Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZF0MPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZF0MPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 08:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZF0MPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 08:15:32 -0400
Received: from www17.your-server.de ([213.133.104.17]:58727 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZF0MPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 08:15:31 -0400
Subject: 2.6.31-rc1: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 16:15:43 +0200
Message-Id: <1246112143.21110.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    1.516209] ------------[ cut here ]------------
[    1.516216] WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask+0x153/0x550()
[    1.516218] Hardware name: MS-7250
[    1.516219] Modules linked in:
[    1.516223] Pid: 1, comm: swapper Not tainted 2.6.31-rc1 #50
[    1.516225] Call Trace:
[    1.516232]  [<ffffffff8106c182>] ? warn_slowpath_common+0x84/0xb2
[    1.516236]  [<ffffffff81178fb8>] ? sysfs_ilookup_test+0x0/0x3b
[    1.516239]  [<ffffffff810e5ea8>] ? __alloc_pages_nodemask+0x153/0x550
[    1.516245]  [<ffffffff811131bd>] ? kmem_cache_create+0x1ac/0x30c
[    1.516249]  [<ffffffff810e6346>] ? __get_free_pages+0x22/0x77
[    1.516253]  [<ffffffff81cb5b8f>] ? dccp_init+0xeb/0x38e
[    1.516257]  [<ffffffff81cb5aa4>] ? dccp_init+0x0/0x38e
[    1.516260]  [<ffffffff8100908e>] ? do_one_initcall+0x60/0x144
[    1.516264]  [<ffffffff810c0040>] ? register_irq_proc+0xac/0xdb
[    1.516268]  [<ffffffff81c6a88f>] ? kernel_init+0x170/0x1dd
[    1.516272]  [<ffffffff8102cf8a>] ? child_rip+0xa/0x20
[    1.516275]  [<ffffffff81c6a71f>] ? kernel_init+0x0/0x1dd
[    1.516278]  [<ffffffff8102cf80>] ? child_rip+0x0/0x20
[    1.516283] ---[ end trace 2e1baf37c897af4d ]---


