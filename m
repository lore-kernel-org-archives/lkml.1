Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbXLLXm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbXLLXm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXLLXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:42:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:35139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbXLLXmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:42:50 -0500
Date: Thu, 13 Dec 2007 00:42:48 +0100
From: Andi Kleen <ak@suse.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, akpm@osdl.org,
       torvalds@osdl.org
Subject: Re: BUG fs/dcache.c:595 in 2.4.24rc3-git3 during NFS umount
Message-ID: <20071212234248.GD31699@bingen.suse.de>
References: <200712031623.58223.ak@suse.de> <200712081422.30815.ak@suse.de> <1197243901.11792.1.camel@heimdal.trondhjem.org> <20071210185720.GA32466@bingen.suse.de> <1197428085.28126.3.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197428085.28126.3.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I appear to have misread d_find_alias(). It would seem that the only way
> to ensure that a mountpoint won't be found is to remove it altogether
> from the inode->i_dentry list. AFAICS that should be largely harmless
> since the nfs sb->s_root is never visible to users, and is never part of
> a dentry tree.

Hasn't BUGed so far with this patch. I'll watch it further but it looks
good so far. Thanks. I would suggest to push the patch.

-Andi

