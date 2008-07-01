Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYGAHE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYGAHE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYGAHES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:04:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYGAHER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:04:17 -0400
Date: Tue, 1 Jul 2008 03:03:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, hooanon05@yahoo.co.jp,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking
Message-ID: <20080701070350.GA22914@infradead.org>
References: <Pine.LNX.4.64.0806291244440.32708@blonde.site> <200806301819.m5UIJRhv030310@agora.fsl.cs.sunysb.edu> <20080630214901.GA8900@halcrowt61p.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630214901.GA8900@halcrowt61p.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 04:49:01PM -0500, Michael Halcrow wrote:
> eCryptfs depends on the results of i_size_read() on the lower inode
> when it needs to interpolate the filesize when the metadata is stored
> in the lower file's xattr region.

please use vfs_getattr to get the size in thst case.

