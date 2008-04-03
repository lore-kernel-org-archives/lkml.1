Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbYDCC1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbYDCC1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbYDCC1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:27:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758660AbYDCC1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:27:20 -0400
Date: Wed, 2 Apr 2008 19:26:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org
Subject: Re: fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add locking
 to copy_inode_size
Message-Id: <20080402192633.722bec28.akpm@linux-foundation.org>
In-Reply-To: <200804030149.m331nBCv005555@agora.fsl.cs.sunysb.edu>
References: <200804030149.m331nBCv005555@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 21:49:11 -0400 Erez Zadok <ezk@cs.sunysb.edu> wrote:

> Andrew, this patch has been in my git tree for a while.  It affects current
> mainline users (i.e., ecryptfs).  Do you think it can go to mainline soon?
> If not, post-25? (I can remind you then).  This patch has a few changes, and
> I can break it into several smaller ones if desired:
> 
> 1. remove the 3rd arg to fsstack_copy_attr_all.  There are no users for it:
>    ecryptfs never used the 3rd arg; unionfs stopped using it a long time
>    ago.  Halcrow ok'ed this patch some time ago.
> 
> 2. add necessary locking for 32-bit smp systems in fsstack_copy_inode_size
>    (courtesy Hugh Dickins).
> 
> 3. minor commenting style changes, and addition of copyrights which were
>    missing.
> 
> Thanks,
> Erez.
> 
> --cut--here----cut--here----cut--here----cut--here----cut--here--
> 
> 
> fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add locking to copy_inode_size

I'm already carrying this, via git-unionfs.  It makes it a bit hard to merge.
I guess resending it during the 2.6.26 merge window would suit.
