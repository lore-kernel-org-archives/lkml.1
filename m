Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbXERUgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbXERUgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXERUgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:36:40 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:57338 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXERUgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:36:40 -0400
Date: Fri, 18 May 2007 22:32:12 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: clameter@sgi.com
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 10/10] ext2 ext3 ext4: support inode slab defragmentation
In-Reply-To: <20070518181120.938438348@sgi.com>
Message-ID: <Pine.LNX.4.61.0705182229140.9015@yvahk01.tjqt.qr>
References: <20070518181040.465335396@sgi.com> <20070518181120.938438348@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 11:10, clameter@sgi.com wrote:
>+
>+static struct kmem_cache_ops ext2_kmem_cache_ops = {
>+	ext2_get_inodes,
>+	kick_inodes
>+};
>+

We love C99 names:

static struct kmem_cache_ops ext2_kmem_cache_ops = {
	.get  = ext2_get_inodes,
	.kick = kick_inodes,
};


	Jan
-- 
