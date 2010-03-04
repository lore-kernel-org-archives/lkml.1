Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab0CDRZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:25:06 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:29982 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0CDRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:25:04 -0500
Date: Thu, 4 Mar 2010 09:23:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Josef Bacik <josef@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup __generic_block_fiemap and fix a few minor
 issues
Message-Id: <20100304092320.12b09851.randy.dunlap@oracle.com>
In-Reply-To: <20100304171253.GB5722@localhost.localdomain>
References: <20100303163715.GB2215@localhost.localdomain>
	<alpine.LFD.2.00.1003040754150.7046@localhost.localdomain>
	<20100304162039.GA5722@localhost.localdomain>
	<20100304085021.1b4e5c58.randy.dunlap@oracle.com>
	<20100304171253.GB5722@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B8FECD7.0063:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 12:12:54 -0500 Josef Bacik wrote:

> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 6c75110..f330fec 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -228,14 +228,23 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
>  
>  
>  /**
>   * __generic_block_fiemap - FIEMAP for block based inodes (no locking)
> - * @inode - the inode to map
> - * @arg - the pointer to userspace where we copy everything to
> - * @get_block - the fs's get_block function
> + * @inode: the inode to map
> + * @fieinfo: the fiemap info struct that will be passed back to userspace
> + * @start: where to start mapping in the inode
> + * @len: how much space to map
> + * @get_block: the fs's get_block function
>   *
>   * This does FIEMAP for block based inodes.  Basically it will just loop
>   * through get_block until we hit the number of extents we want to map, or we

That's good.  Thank you.

---
~Randy
