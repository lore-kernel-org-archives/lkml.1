Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZDOQQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZDOQQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZDOQPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:15:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36182 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZDOQPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:15:52 -0400
Date: Wed, 15 Apr 2009 18:15:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [GIT PATCH block#for-linus] block: various fixes
Message-ID: <20090415161550.GO5178@kernel.dk>
References: <1239801027-9201-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239801027-9201-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15 2009, Tejun Heo wrote:
> Hello,
> 
> This patchset contains the following five block related fix patches.
> 
>  0001-scatterlist-make-sure-sg_miter_next-doesn-t-retur.patch
>  0002-block-fix-SG_IO-vector-request-data-length-handling.patch
>  0003-block-fix-queue-bounce-limit-setting.patch
>  0004-bio-fix-bio_kmalloc.patch
>  0005-bio-use-bio_kmalloc-in-copy-map-functions.patch
> 
> 0001-0003 are unchanged re-posting of the first three patches of
> blk-map-related-fixes[1].  The fourth patch of the previous patchset
> is dropped and 0004 reimplements bio_kmalloc() as per Jens'
> suggestion.  0005 is new and uses bio_kmalloc() in the map functions.
> 
> This patchset is also available in the following git tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-fixes
> 
> and contains the following changes.

Thanks a lot, Tejun! I'll add these and include them in the next 2.6.30
push.

-- 
Jens Axboe

