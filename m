Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbXBRUWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbXBRUWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXBRUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:22:43 -0500
Received: from lixom.net ([66.141.50.11]:36020 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXBRUWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:22:42 -0500
Date: Sun, 18 Feb 2007 14:32:14 -0600
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfs: init req_lock in nfs_alloc_inode
Message-ID: <20070218203214.GA31004@lixom.net>
References: <20070216170532.GA4895@lixom.net> <20070216172442.fd75d8d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216172442.fd75d8d8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 05:24:42PM -0800, Andrew Morton wrote:

> req_lock is initialsied in fs/nfs/inode.c:init_once().

Oh, it is indeed. Grmbl.

> What kernel version were you using?

I've reproduced this on a base 2.6.20 g5_defconfig + NFS root and serial
console options on a G5 here.

The steps I have used are:

* Boot with NFS root, default mount options
* mount /dev/sda3 /mnt

... that's all. I have not seen it happen without NFS root, even with
quite active NFS activity. So it seems to be a factor.

I'll continue debugging tomorrow.

-Olof
