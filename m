Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYJ3Jvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYJ3Jvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYJ3Jvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:51:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:33737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYJ3Jvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:51:36 -0400
Message-ID: <4909839D.1020508@kernel.org>
Date: Thu, 30 Oct 2008 18:51:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mike Anderson <andmike@linux.vnet.ibm.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] block: add timer on blkdev_dequeue_request() not	elv_next_request()
References: <490927CD.2010205@kernel.org> <20081030072956.GL31673@kernel.dk> <49096865.2050006@kernel.org> <20081030075855.GO31673@kernel.dk> <20081030092741.GA9478@linux.vnet.ibm.com>
In-Reply-To: <20081030092741.GA9478@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Oct 2008 09:51:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Anderson wrote:
> From: Mike Anderson <andmike@linux.vnet.ibm.com>
> Date: Thu, 30 Oct 2008 02:16:20 -0700
> Subject: [PATCH 1/1] blk: move blk_delete_timer call in end_that_request_last
> 
> Move the calling  blk_delete_timer to later in end_that_request_last to
> address an issue where blkdev_dequeue_request may have add a timer for the
> request.
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch definitely is necessary.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
