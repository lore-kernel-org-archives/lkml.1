Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbXJWVRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbXJWVRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXJWVRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:17:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35724
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXJWVRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:17:33 -0400
Date: Tue, 23 Oct 2007 14:18:00 -0700 (PDT)
Message-Id: <20071023.141800.59467535.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: IDE crash...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071023105710.GJ5059@kernel.dk>
References: <20071023.004321.74750417.davem@davemloft.net>
	<20071023195255S.fujita.tomonori@lab.ntt.co.jp>
	<20071023105710.GJ5059@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 23 Oct 2007 12:57:11 +0200

> On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> > BTW, we avoid calling sg_init_table() for every I/O request due to Jens'
> > trick. And Jens will remove the code to clear sg_dma_len/addr in
> > blk_rq_map_sg(). So sparc64 iommu needs to do that for itself?
> > 
> > http://marc.info/?l=linux-scsi&m=119261920425120&w=2
> 
> It does - Dave, do you agree with the patch? I think it should be added,
> so that sparc64 isn't the odd-arch-out in this respect. I've tentatively
> applied the patch, Davem?

No objections.
