Return-Path: <linux-kernel-owner+w=401wt.eu-S965763AbXIBLxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763AbXIBLxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964926AbXIBLxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:53:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964889AbXIBLxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:53:46 -0400
Date: Sun, 2 Sep 2007 04:53:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3: sysfs_remove_bin_file: bad dentry or inode or no
 such file: "descriptors"
Message-Id: <20070902045349.b59af405.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.999.0708142335120.21213@mtl.rackplans.net>
References: <alpine.DEB.0.999.0708142335120.21213@mtl.rackplans.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 14 Aug 2007 23:36:32 -0400 (EDT) Gerhard Mack <gmack@innerfire.net> wrote:
> hello, 
> 
> Got this when I booted into 2.6.23-rc3:  Let me know if more info is 
> needed.
> 
> 	Gerhard
> 
> 
> sysfs_remove_bin_file: bad dentry or inode or no such file: "descriptors"
> 
> Call Trace:
>  [<ffffffff80480117>] usb_remove_sysfs_dev_files+0x89/0x9d
>  [<ffffffff8047cf29>] usb_unbind_device+0x15/0x19
>  [<ffffffff803f855e>] __device_release_driver+0x8e/0xb0
>  [<ffffffff803f8953>] device_release_driver+0x2c/0x44
>  [<ffffffff803f7e56>] bus_remove_device+0x6e/0x7d
>  [<ffffffff803f6641>] device_del+0x1ec/0x268
>  [<ffffffff80477af3>] usb_disconnect+0xbc/0x149
>  [<ffffffff804782c2>] hub_thread+0x3f8/0xba5
>  [<ffffffff805e3463>] thread_return+0x57/0xdf
>  [<ffffffff80244f0b>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff80477eca>] hub_thread+0x0/0xba5
>  [<ffffffff80244df3>] kthread+0x47/0x74
>  [<ffffffff8020c588>] child_rip+0xa/0x12
>  [<ffffffff8021b96a>] flat_send_IPI_mask+0x0/0x4c
>  [<ffffffff80244dac>] kthread+0x0/0x74
>  [<ffffffff8020c57e>] child_rip+0x0/0x12
> 

Is this still happening in 2.6.23-rc4 or later?
