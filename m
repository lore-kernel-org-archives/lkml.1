Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYHNPih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYHNPih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYHNPi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:38:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12185 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYHNPi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:38:27 -0400
Date: Thu, 14 Aug 2008 08:38:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       ak@linux.intel.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Message-Id: <20080814083828.d10e126d.randy.dunlap@oracle.com>
In-Reply-To: <20080814172945.250a27f2.sfr@canb.auug.org.au>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calling  param_sysfs_init+0x0/0x1e7
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc3-next-20080814 #1

Call Trace:
 [<ffffffff802358cb>] warn_slowpath+0xae/0xdd
 [<ffffffff8036a6be>] ? number+0x115/0x21f
 [<ffffffff8036574d>] ? __next_cpu+0x19/0x26
 [<ffffffff8022d575>] ? find_busiest_group+0x25b/0x6ee
 [<ffffffff8036aefc>] ? string+0x3d/0xa2
 [<ffffffff80365e02>] ? idr_get_empty_slot+0x161/0x24e
 [<ffffffff8036b2ea>] ? vsnprintf+0x389/0x678
 [<ffffffff802def96>] ? sysfs_ilookup_test+0x0/0x14
 [<ffffffff802aa5bf>] ? ifind+0x3d/0xac
 [<ffffffff802df1bd>] ? sysfs_find_dirent+0x1c/0x31
 [<ffffffff802df1f1>] ? __sysfs_add_one+0x1f/0x7c
 [<ffffffff802df283>] sysfs_add_one+0x35/0x3d
 [<ffffffff802df7d2>] create_dir+0x58/0x93
 [<ffffffff802df845>] sysfs_create_dir+0x38/0x4f
 [<ffffffff80366b8a>] kobject_add_internal+0xce/0x18f
 [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
 [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
 [<ffffffff803676e5>] ? kobject_uevent_env+0x350/0x37f
 [<ffffffff802455bf>] ? param_sysfs_setup+0xe1/0x104
 [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
 [<ffffffff80764bee>] param_sysfs_init+0x163/0x1e7
 [<ffffffff80249b00>] ? ktime_get_ts+0x14/0x4e
 [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x1e7
 [<ffffffff80209047>] _stext+0x47/0x13f
 [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
 [<ffffffff807508e5>] kernel_init+0x11b/0x171
 [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
 [<ffffffff8020ce49>] child_rip+0xa/0x11
 [<ffffffff807507ca>] ? kernel_init+0x0/0x171
 [<ffffffff8020ce3f>] ? child_rip+0x0/0x11

---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc3-next-20080814 #1

Call Trace:
 [<ffffffff8036698f>] ? kobject_put+0x47/0x4b
 [<ffffffff80366c08>] kobject_add_internal+0x14c/0x18f
 [<ffffffff80366d17>] kobject_add_varg+0x41/0x4d
 [<ffffffff80366d91>] kobject_init_and_add+0x6e/0x7c
 [<ffffffff803676e5>] ? kobject_uevent_env+0x350/0x37f
 [<ffffffff802455bf>] ? param_sysfs_setup+0xe1/0x104
 [<ffffffff80764a30>] kernel_param_sysfs_setup+0x6b/0xc6
 [<ffffffff80764bee>] param_sysfs_init+0x163/0x1e7
 [<ffffffff80249b00>] ? ktime_get_ts+0x14/0x4e
 [<ffffffff80764a8b>] ? param_sysfs_init+0x0/0x1e7
 [<ffffffff80209047>] _stext+0x47/0x13f
 [<ffffffff80269f25>] ? register_irq_proc+0xb7/0xd3
 [<ffffffff807508e5>] kernel_init+0x11b/0x171
 [<ffffffff802311ef>] ? schedule_tail+0x28/0x60
 [<ffffffff8020ce49>] child_rip+0xa/0x11
 [<ffffffff807507ca>] ? kernel_init+0x0/0x171
 [<ffffffff8020ce3f>] ? child_rip+0x0/0x11

Module 'acpi' failed to be added to sysfs, error number -17
The system will be unstable now.
initcall param_sysfs_init+0x0/0x1e7 returned 0 after 19 msecs


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
