Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZINN6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZINN6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbZINN6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:58:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbZINN6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:58:48 -0400
Date: Mon, 14 Sep 2009 09:58:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: bdev->bd_inode_backing_dev_info?
Message-ID: <20090914135851.GA384@infradead.org>
References: <20090914094119.GZ14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914094119.GZ14984@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 11:41:19AM +0200, Jens Axboe wrote:
> Hi,
> 
> This looks a bit odd, what is the purpose of that? It also appears
> currently to be unused, it's never set to anything but NULL.

It was introduced in:

commit 520808bf20e90fdbdb320264ba7dd5cf9d47dcac
Author: Andrew Morton <akpm@osdl.org>
Date:   Fri May 21 00:46:17 2004 -0700

    [PATCH] block device layer: separate backing_dev_info infrastructure

and already never set in that commit.

I'd say nuke it.
