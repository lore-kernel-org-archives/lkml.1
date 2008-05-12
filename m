Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYELAtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYELAtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 20:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYELAt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 20:49:28 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:41712 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYELAt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 20:49:27 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_* updates 
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, mhalcrow@us.ibm.com, hugh@veritas.com
In-Reply-To: <200805020558.m425w5xN001504@agora.fsl.cs.sunysb.edu>
References: Your message of "Thu, 01 May 2008 17:08:19 PDT." <20080501170819.bdcb9035.akpm@linux-foundation.org> <200805020558.m425w5xN001504@agora.fsl.cs.sunysb.edu>
Date: Mon, 12 May 2008 09:44:28 +0900
Message-ID: <7830.1210553068@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Erez Zadok:
> The nice thing about these two helpers is fsstack_copy_inode_size becomes a
> lot cleaner and more elegant:
> 
> void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
> {
> 	i_blocks_write(dst, i_blocks_read(src));
> 	i_size_write(dst, i_size_read(src));
> }

While this function looks simple, I think it is more generic and better
that the caller of fsstack_copy_inode_size() holds i_lock instead of
lock it in the callee.


Junjiro Okajima
