Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbYHLHLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbYHLHLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYHLHLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:11:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38191 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYHLHLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:11:37 -0400
Message-ID: <48A136D7.4080505@cs.helsinki.fi>
Date: Tue, 12 Aug 2008 10:08:07 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com
Subject: Re: [patch 15/19] Filesystem: XFS slab defragmentation
References: <20080811150616.207532384@quilx.com> <20080811150659.051842926@quilx.com> <20080812002057.GH6119@disturbed>
In-Reply-To: <20080812002057.GH6119@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Mon, Aug 11, 2008 at 08:06:31AM -0700, Christoph Lameter wrote:
>> Support inode defragmentation for xfs
>>
>> Reviewed-by: Rik van Riel <riel@redhat.com>
>> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>>
>> ---
>>  fs/xfs/linux-2.6/xfs_super.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> Index: linux-next/fs/xfs/linux-2.6/xfs_super.c
>> ===================================================================
>> --- linux-next.orig/fs/xfs/linux-2.6/xfs_super.c	2008-08-11 07:42:11.892359719 -0700
>> +++ linux-next/fs/xfs/linux-2.6/xfs_super.c	2008-08-11 07:47:05.072348463 -0700
>> @@ -1947,6 +1947,7 @@ xfs_init_zones(void)
>>  	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
>>  	if (!xfs_ioend_zone)
>>  		goto out_destroy_vnode_zone;
>> +	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
>>  
>>  	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
>>  						  xfs_ioend_zone);
> 
> Please update this patch as per my last comment.

Christoph, I'm dropping this patch from my tree.
