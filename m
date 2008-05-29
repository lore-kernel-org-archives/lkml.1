Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYE2MXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYE2MXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYE2MXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:23:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48936 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYE2MXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:23:07 -0400
Date: Thu, 29 May 2008 06:23:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] vfs: dcache cleanups
Message-ID: <20080529122305.GP22636@parisc-linux.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113307.432012922@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529113307.432012922@szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:32:46PM +0200, Miklos Szeredi wrote:
> d_path() cleanups and fix the following sparse warnings:
> 
> fs/dcache.c:2183:19: warning: symbol 'filp_cachep' was not declared. Should it be static?
> fs/dcache.c:115:3: warning: context imbalance in 'dentry_iput' - unexpected unlock
> fs/dcache.c:188:2: warning: context imbalance in 'dput' - different lock contexts for basic block
> fs/dcache.c:400:2: warning: context imbalance in 'prune_one_dentry' - different lock contexts for basic block
> fs/dcache.c:431:22: warning: context imbalance in 'prune_dcache' - different lock contexts for basic block
> fs/dcache.c:563:2: warning: context imbalance in 'shrink_dcache_sb' - different lock contexts for basic block
> fs/dcache.c:1385:6: warning: context imbalance in 'd_delete' - wrong count at exit
> fs/dcache.c:1636:2: warning: context imbalance in '__d_unalias' - unexpected unlock
> fs/dcache.c:1735:2: warning: context imbalance in 'd_materialise_unique' - different lock contexts for basic block
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
