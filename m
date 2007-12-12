Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXLLR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXLLR2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXLLR2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:28:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbXLLR2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:28:36 -0500
Date: Wed, 12 Dec 2007 12:27:52 -0500 (EST)
Message-Id: <20071212.122752.104028559.k-ueda@ct.jp.nec.com>
To: Mike.Miller@hp.com
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 21/30] blk_end_request: changing cciss (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <DEE40752C8AF224BB890E455C7B8E0FE15718B35@G6W0268.americas.hpqcorp.net>
References: <20071211.175003.10249786.k-ueda@ct.jp.nec.com>
	<DEE40752C8AF224BB890E455C7B8E0FE15718B35@G6W0268.americas.hpqcorp.net>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, 12 Dec 2007 15:25:10 +0000, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:
> > Index: 2.6.24-rc4/drivers/block/cciss.c
> > ===================================================================
> > --- 2.6.24-rc4.orig/drivers/block/cciss.c
> > +++ 2.6.24-rc4/drivers/block/cciss.c
snip
> > +2526,6 @@ after_error_processing:
> >         }
> >         cmd->rq->data_len = 0;
> >         cmd->rq->completion_data = cmd;
> > -       blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
> 
> Why is this removed?

Sorry for the less explanation.

Because it is done in __end_that_request_first() called from
blk_end_request().
I'll add the explanation to the patch description when I update
the patch.

Thanks,
Kiyoshi Ueda
