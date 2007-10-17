Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbXJQHW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbXJQHW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 03:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbXJQHWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 03:22:17 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18808 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXJQHWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 03:22:16 -0400
Date: Wed, 17 Oct 2007 09:21:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Message-ID: <20071017072149.GC5041@kernel.dk>
References: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> Commit 2c941a204070ab32d92d40318a3196a7fb994c00 looks incomplete. The
> helper functions like prepare_sg() need to support sg chaining too.

Thanks Tomo, applied. I'll get this pushed out later today with any
other sg chaining fallout we may see.

-- 
Jens Axboe

