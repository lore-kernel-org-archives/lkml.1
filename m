Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbXERVDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbXERVDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXERVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:03:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40131 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754083AbXERVDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:03:16 -0400
Date: Fri, 18 May 2007 14:03:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 10/10] ext2 ext3 ext4: support inode slab defragmentation
In-Reply-To: <Pine.LNX.4.61.0705182229140.9015@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0705181402060.13256@schroedinger.engr.sgi.com>
References: <20070518181040.465335396@sgi.com> <20070518181120.938438348@sgi.com>
 <Pine.LNX.4.61.0705182229140.9015@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Jan Engelhardt wrote:

> 
> On May 18 2007 11:10, clameter@sgi.com wrote:
> >+
> >+static struct kmem_cache_ops ext2_kmem_cache_ops = {
> >+	ext2_get_inodes,
> >+	kick_inodes
> >+};
> >+
> 
> We love C99 names:
> 
> static struct kmem_cache_ops ext2_kmem_cache_ops = {
> 	.get  = ext2_get_inodes,
> 	.kick = kick_inodes,
> };
> 

Right. The other patches all have C99 names in kmem_cache_ops. The mass 
handling of extxx filesystems must have made me loose sight of that. Next 
rev will have it.

