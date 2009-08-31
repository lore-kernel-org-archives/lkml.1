Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZHaNCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZHaNCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZHaNC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:02:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49948 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbZHaNC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:02:28 -0400
Date: Mon, 31 Aug 2009 09:02:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 06/10] writeback: allow sleepy exit of default
	writeback task
Message-ID: <20090831130230.GD20465@infradead.org>
References: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com> <1251720891-19793-7-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251720891-19793-7-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 02:14:47PM +0200, Jens Axboe wrote:
> Since we do lazy create of default writeback tasks for a bdi, we can
> allow sleepy exit if it has been completely idle for 5 minutes.

Any reason this is not merged into patch 2?

