Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZIKSP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZIKSP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZIKSP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:15:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbZIKSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:15:58 -0400
Date: Fri, 11 Sep 2009 14:16:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 2/4] Assign bdi in super_block
Message-ID: <20090911181600.GA21792@infradead.org>
References: <1252669832-13553-1-git-send-email-jens.axboe@oracle.com> <1252669832-13553-3-git-send-email-jens.axboe@oracle.com> <20090911180106.GB19598@infradead.org> <20090911181227.GM14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911181227.GM14984@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 08:12:27PM +0200, Jens Axboe wrote:
> Good question, I was indeed looking for an sb equivalent of that bdi
> flag. And now ->s_bdi being set or not is indeed that. Some of our
> generated writeback originates at the bdi level though, so we may or may
> not have the sb. From a quick look at fs-writeback.c, it looks feasible
> though. I'll try.
> 
> Can I take that as an acked-by?

Yes.
