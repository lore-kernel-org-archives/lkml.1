Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYDUVXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYDUVXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbYDUVVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:21:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:6255 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbYDUVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=F56uVPVk0PwP4PJDSxIhU+jzDMToAz0sJNY6lXKxZ6yzFg/j7spQL7Fo5LNB2rl23tk2pJnbBnJPnx/XEIVlqDzeRn0tZeG6lYjz9ztSyJMph03kt1ShHkn8c64RblZA91HO8zaxbOAHE78nPllxCThX4HzojDDzL+8ST5/1U0k=
Date: Mon, 21 Apr 2008 23:21:45 +0200 (CEST)
To: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] [TRIVIAL] ext*: spelling fix prefered -> preferred
In-Reply-To: <20080319202319.GD6935@ens-lyon.fr>
Message-ID: <alpine.LNX.1.00.0804212320420.1777@dragon.funnycrock.com>
References: <20080319202319.GD6935@ens-lyon.fr>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've applied this patch to the trivial tree, since I don't see it merged 
elsewhere and it looks obviously correct.

/Jesper Juhl


On Wed, 19 Mar 2008, Benoit Boissinot wrote:

> Spelling fix: prefered -> preferred
> 
> Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
> 
> diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext2/ialloc.c
> --- a/fs/ext2/ialloc.c	Tue Mar 18 21:34:48 2008 -0700
> +++ b/fs/ext2/ialloc.c	Wed Mar 19 21:01:45 2008 +0100
> @@ -253,7 +253,7 @@
>   * it has too few free inodes left (min_inodes) or 
>   * it has too few free blocks left (min_blocks) or 
>   * it's already running too large debt (max_debt). 
> - * Parent's group is prefered, if it doesn't satisfy these 
> + * Parent's group is preferred, if it doesn't satisfy these 
>   * conditions we search cyclically through the rest. If none 
>   * of the groups look good we just look for a group with more 
>   * free inodes than average (starting at parent's group). 
> diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext2/inode.c
> --- a/fs/ext2/inode.c	Tue Mar 18 21:34:48 2008 -0700
> +++ b/fs/ext2/inode.c	Wed Mar 19 21:01:45 2008 +0100
> @@ -239,7 +239,7 @@
>   *	@inode: owner
>   *	@ind: descriptor of indirect block.
>   *
> - *	This function returns the prefered place for block allocation.
> + *	This function returns the preferred place for block allocation.
>   *	It is used when heuristic for sequential allocation fails.
>   *	Rules are:
>   *	  + if there is a block to the left of our position - allocate near it.
> @@ -283,7 +283,7 @@
>  }
>  
>  /**
> - *	ext2_find_goal - find a prefered place for allocation.
> + *	ext2_find_goal - find a preferred place for allocation.
>   *	@inode: owner
>   *	@block:  block we want
>   *	@partial: pointer to the last triple within a chain
> diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext3/ialloc.c
> --- a/fs/ext3/ialloc.c	Tue Mar 18 21:34:48 2008 -0700
> +++ b/fs/ext3/ialloc.c	Wed Mar 19 21:01:45 2008 +0100
> @@ -239,7 +239,7 @@
>   * it has too few free inodes left (min_inodes) or
>   * it has too few free blocks left (min_blocks) or
>   * it's already running too large debt (max_debt).
> - * Parent's group is prefered, if it doesn't satisfy these
> + * Parent's group is preferred, if it doesn't satisfy these
>   * conditions we search cyclically through the rest. If none
>   * of the groups look good we just look for a group with more
>   * free inodes than average (starting at parent's group).
> diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext3/inode.c
> --- a/fs/ext3/inode.c	Tue Mar 18 21:34:48 2008 -0700
> +++ b/fs/ext3/inode.c	Wed Mar 19 21:01:45 2008 +0100
> @@ -392,7 +392,7 @@
>   *	@inode: owner
>   *	@ind: descriptor of indirect block.
>   *
> - *	This function returns the prefered place for block allocation.
> + *	This function returns the preferred place for block allocation.
>   *	It is used when heuristic for sequential allocation fails.
>   *	Rules are:
>   *	  + if there is a block to the left of our position - allocate near it.
> @@ -436,12 +436,12 @@
>  }
>  
>  /**
> - *	ext3_find_goal - find a prefered place for allocation.
> + *	ext3_find_goal - find a preferred place for allocation.
>   *	@inode: owner
>   *	@block:  block we want
>   *	@partial: pointer to the last triple within a chain
>   *
> - *	Normally this function find the prefered place for block allocation,
> + *	Normally this function find the preferred place for block allocation,
>   *	returns it.
>   */
>  
> diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext4/ialloc.c
> --- a/fs/ext4/ialloc.c	Tue Mar 18 21:34:48 2008 -0700
> +++ b/fs/ext4/ialloc.c	Wed Mar 19 21:01:45 2008 +0100
> @@ -305,7 +305,7 @@
>   * it has too few free inodes left (min_inodes) or
>   * it has too few free blocks left (min_blocks) or
>   * it's already running too large debt (max_debt).
> - * Parent's group is prefered, if it doesn't satisfy these
> + * Parent's group is preferred, if it doesn't satisfy these
>   * conditions we search cyclically through the rest. If none
>   * of the groups look good we just look for a group with more
>   * free inodes than average (starting at parent's group).
> diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext4/inode.c
> --- a/fs/ext4/inode.c	Tue Mar 18 21:34:48 2008 -0700
> +++ b/fs/ext4/inode.c	Wed Mar 19 21:01:45 2008 +0100
> @@ -382,7 +382,7 @@
>   *	@inode: owner
>   *	@ind: descriptor of indirect block.
>   *
> - *	This function returns the prefered place for block allocation.
> + *	This function returns the preferred place for block allocation.
>   *	It is used when heuristic for sequential allocation fails.
>   *	Rules are:
>   *	  + if there is a block to the left of our position - allocate near it.
> @@ -432,12 +432,12 @@
>  }
>  
>  /**
> - *	ext4_find_goal - find a prefered place for allocation.
> + *	ext4_find_goal - find a preferred place for allocation.
>   *	@inode: owner
>   *	@block:  block we want
>   *	@partial: pointer to the last triple within a chain
>   *
> - *	Normally this function find the prefered place for block allocation,
> + *	Normally this function find the preferred place for block allocation,
>   *	returns it.
>   */
>  static ext4_fsblk_t ext4_find_goal(struct inode *inode, ext4_lblk_t block,
> 
> -- 
> :wq
> 
