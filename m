Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZHFVda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZHFVda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbZHFVd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:33:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbZHFVd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:33:29 -0400
Date: Thu, 6 Aug 2009 17:33:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 5/9] writeback: support > 1 flusher thread per bdi
Message-ID: <20090806213326.GA20538@infradead.org>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-6-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248989044-21605-6-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 11:24:00PM +0200, Jens Axboe wrote:
> Build on the bdi_writeback support by allowing registration of
> more than 1 flusher thread. File systems can call bdi_add_flusher_task(bdi)
> to add more flusher threads to the device. If they do so, they must also
> provide a super_operations function to return the suitable bdi_writeback
> struct from any given inode.

Please don't add a inode_get_wb method until we actually have users for it.

