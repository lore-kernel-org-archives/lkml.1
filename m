Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbZIRUdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbZIRUdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZIRUd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:33:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53246 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbZIRUdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:33:25 -0400
Date: Fri, 18 Sep 2009 22:33:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>, David Strand <dpstrand@gmail.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Message-ID: <20090918203328.GT23126@kernel.dk>
References: <4AB3B43D.9000802@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB3B43D.9000802@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19 2009, Jun'ichi Nomura wrote:
> This patch is a preparation for the last patch in this patchset
> which changes blk_set_default_limits() to set 0 to max_sectors.
> 
> dm uses blk_stack_limits() to merge limits of underlying devices
> and copy the end result to the queue.
> But if there's no underlying device (like 'zero' target),
> max_sectors/max_hw_sectors are left unchanged from the default 0
> and just copying it to the queue causes problems.
> 
> Provide blk_queue_copy_limits() to get a safe copy with
> invalid values fixed-up.

Added for 2.6.32.

-- 
Jens Axboe

