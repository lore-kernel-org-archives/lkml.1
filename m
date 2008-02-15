Return-Path: <linux-kernel-owner+w=401wt.eu-S1764730AbYBOLJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764730AbYBOLJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYBOLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:08:58 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:19212 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYBOLI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:08:57 -0500
Date: Fri, 15 Feb 2008 14:08:53 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc1-sha1: WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
Message-ID: <20080215110853.GH6110@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting without SYSFS fills dmesg like this

------------[ cut here ]------------
WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
Modules linked in: loop(+)
Pid: 994, comm: modprobe Tainted: G   M     2.6.25-rc1 #6

Call Trace:
 [<ffffffff802317f4>] warn_on_slowpath+0x64/0x90
 [<ffffffff8028db08>] init_object+0x88/0xa0
 [<ffffffff8028f55e>] __slab_alloc+0xbe/0x550
 [<ffffffff8031aa28>] kvasprintf+0x58/0x90
 [<ffffffff8031874c>] vsnprintf+0x33c/0x6e0
 [<ffffffff8031aa41>] kvasprintf+0x71/0x90
 [<ffffffff8022c597>] hrtick_set+0x77/0x140
 [<ffffffff80314860>] kref_get+0x20/0x30
 [<ffffffff80313932>] kobject_get+0x12/0x20
 [<ffffffff803139f9>] kobject_add_internal+0x49/0xf0
 [<ffffffff80313bb3>] kobject_add_varg+0x73/0x80
 [<ffffffff80313fa4>] kobject_add+0x54/0x80
 [<ffffffff8028ec53>] check_object+0x103/0x230
 [<ffffffff8028db08>] init_object+0x88/0xa0
 [<ffffffff80313744>] kobject_create+0x14/0x40
 [<ffffffff8028fbd3>] kmem_cache_alloc+0xd3/0xe0
 [<ffffffff803136b4>] kobject_init+0x34/0xb0
 [<ffffffff8031375b>] kobject_create+0x2b/0x40
 [<ffffffff8031400c>] kobject_create_and_add+0x3c/0x80
 [<ffffffff8025e137>] load_module+0x1847/0x1970
 [<ffffffff80288800>] alloc_pages_current+0x0/0x90
 [<ffffffff8025e2c2>] sys_init_module+0x62/0x1a0

