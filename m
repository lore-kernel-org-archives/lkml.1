Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbZDIKYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbZDIKYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758757AbZDIKYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:24:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449AbZDIKYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:24:19 -0400
Date: Thu, 9 Apr 2009 12:24:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: WARNING at linux/security.h:1889 expand_downwards
Message-ID: <20090409102416.GA21280@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Haven't seen this one on kerneloops.org, so let's post it.

I get this warning all the time on one of my test boxes at boot with 2.6.30rc1

Config is at http://halobates.de/config1

-Andi


Freeing unused kernel memory: 600k freed
------------[ cut here ]------------
WARNING: at /home/ak/lsrc/newmce/linux/include/linux/security.h:1889 expand_downwards+0xee/0x179()
Hardware name: MS-7383
Modules linked in:
Pid: 3110, comm: khelper Not tainted 2.6.30-rc1 #68
Call Trace:
 [<ffffffff8023d333>] warn_slowpath+0xd3/0x10f
 [<ffffffff802a0129>] ? expand_downwards+0x3c/0x179
 [<ffffffff802a01db>] expand_downwards+0xee/0x179
 [<ffffffff802a02b2>] find_extend_vma+0x41/0x6b
 [<ffffffff8029cbee>] __get_user_pages+0x7f/0x3f9
 [<ffffffff8029cf9a>] get_user_pages+0x32/0x34
 [<ffffffff802bec23>] get_arg_page+0x4b/0xab
 [<ffffffff802bee6c>] copy_strings+0xfe/0x1e1
 [<ffffffff802c02e6>] do_execve+0x1c6/0x378
 [<ffffffff8020a579>] sys_execve+0x3e/0x60
 [<ffffffff8020cbf8>] kernel_execve+0x68/0xd0
 [<ffffffff8024cca8>] ? ____call_usermodehelper+0x145/0x150
 [<ffffffff8020cb7a>] child_rip+0xa/0x20
 [<ffffffff8020c53c>] ? restore_args+0x0/0x30
 [<ffffffff8024cb63>] ? ____call_usermodehelper+0x0/0x150
 [<ffffffff8020cb70>] ? child_rip+0x0/0x20
---[ end trace 270f2814994f6bd3 ]---
eth0: no IPv6 routers present

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
