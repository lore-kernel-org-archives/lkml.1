Return-Path: <linux-kernel-owner+w=401wt.eu-S1764538AbXKNGiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764538AbXKNGiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbXKNGiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:38:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759968AbXKNGiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:38:10 -0500
Date: Tue, 13 Nov 2007 22:38:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071113223802.2ace1a61.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 14:18:39 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> Hi,
> Boot failed on my machine. hand copy some messages.
> 
> First with BLK_DEV_RAM=y
> 
> BUG kmalloc-64 Poison overwritting:
> Alloced in kset_create
> Freed in kobject_cleanup
> 
> --cut--
> alloc_disk_node
> rd_init
> kernel_init
> --cut--
> 
> Then config ramdisk as module, build and reboot:
> 
> BUG: unable handle paging resuest at 6b6b6b6b
> EIP is kobject_add 0xc4/0x150
> 
> --cut--
> kobject_set_name
> register_disk
> add_disk
> exact_match
> exact_lock
> loop_init
> --cut--
> 

erp.  Can you send the config over please?

And which distro/version is that machine running?

Thanks.
