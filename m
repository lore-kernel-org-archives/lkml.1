Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYFJUTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYFJUTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYFJUTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:19:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50932 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYFJUTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:19:06 -0400
Subject: Re: [2.6 patch] jfs: remove DIRENTSIZ
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080609222729.GA1987@cs181133002.pp.htv.fi>
References: <20080609222729.GA1987@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 15:19:03 -0500
Message-Id: <1213129143.6435.6.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack.

Added to the jfs git tree.  As this is an unused macro, removing the
definition of struct dirent shouldn't depend on this patch.  Expect it
to make the 2.6.27 merge window.

Thanks,
Shaggy

On Tue, 2008-06-10 at 01:27 +0300, Adrian Bunk wrote:
> After fat gets fixed the unused DIRENTSIZ macro was the last user of
> struct dirent we should get rid of since the kernel and userspace 
> versions differed.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 89432c9b7ff2cd2e29fc5f2edde120dc38a89f46 diff --git a/fs/jfs/jfs_dtree.h b/fs/jfs/jfs_dtree.h
> index cdac2d5..2545bb3 100644
> --- a/fs/jfs/jfs_dtree.h
> +++ b/fs/jfs/jfs_dtree.h
> @@ -243,9 +243,6 @@ typedef union {
>  #define JFS_REMOVE 3
>  #define JFS_RENAME 4
>  
> -#define DIRENTSIZ(namlen) \
> -    ( (sizeof(struct dirent) - 2*(JFS_NAME_MAX+1) + 2*((namlen)+1) + 3) &~ 3 )
> -
>  /*
>   * Maximum file offset for directories.
>   */
> 
-- 
David Kleikamp
IBM Linux Technology Center

