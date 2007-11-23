Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbXKWIRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbXKWIRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 03:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbXKWIRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 03:17:41 -0500
Received: from brick.kernel.dk ([87.55.233.238]:6784 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbXKWIRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 03:17:40 -0500
Date: Fri, 23 Nov 2007 09:17:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix memory leak in alloc_disk_node()
Message-ID: <20071123081715.GB2863@kernel.dk>
References: <47459985.4080700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47459985.4080700@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22 2007, Jerome Marchand wrote:
> Fix a memory leak in alloc_disk_node(). Don't forget to free 'dkstats'
> when the allocation of 'part' failed.

Thanks, applied.

-- 
Jens Axboe

