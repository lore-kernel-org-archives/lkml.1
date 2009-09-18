Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbZIRUf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbZIRUf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbZIRUff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:35:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53279 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbZIRUfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:35:30 -0400
Date: Fri, 18 Sep 2009 22:35:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>, David Strand <dpstrand@gmail.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Message-ID: <20090918203533.GU23126@kernel.dk>
References: <4AB3B43D.9000802@ce.jp.nec.com> <20090918203328.GT23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918203328.GT23126@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009, Jens Axboe wrote:
> On Sat, Sep 19 2009, Jun'ichi Nomura wrote:
> > This patch is a preparation for the last patch in this patchset
> > which changes blk_set_default_limits() to set 0 to max_sectors.
> > 
> > dm uses blk_stack_limits() to merge limits of underlying devices
> > and copy the end result to the queue.
> > But if there's no underlying device (like 'zero' target),
> > max_sectors/max_hw_sectors are left unchanged from the default 0
> > and just copying it to the queue causes problems.
> > 
> > Provide blk_queue_copy_limits() to get a safe copy with
> > invalid values fixed-up.
> 
> Added for 2.6.32.

And removed, it's white space damaged and doesn't apply to the current
tree.

-- 
Jens Axboe

