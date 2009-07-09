Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZGISRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZGISRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZGISRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:17:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46033 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbZGISRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:17:14 -0400
Date: Thu, 9 Jul 2009 20:17:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH]: Rename REQ_COPY_USER to more descriptive
	REQ_HAS_TAIL_SPACE_FOR_PADDING
Message-ID: <20090709181713.GQ23611@kernel.dk>
References: <4A563259.5000601@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A563259.5000601@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09 2009, Vladislav Bolkhovitin wrote:
> Currently names of REQ_COPY_USER and __REQ_COPY_USER constants are confusing,
> because they actually mean that the buffer for the corresponding requests
> has space in the tail for padding in case of DMA padding restrictions.

No, that's not what it means, the fact that there's padding room is a
side effect of the map type. So I'd suggest adding a comment above that
if {} in blk_rq_map_sg(), something that should have been there from the
beginning.

-- 
Jens Axboe

