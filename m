Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbXGPNYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbXGPNYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbXGPNYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:24:42 -0400
Received: from brick.kernel.dk ([80.160.20.94]:27532 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977AbXGPNYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:24:42 -0400
Date: Mon, 16 Jul 2007 15:23:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <tomof@acm.org>
Cc: mark_salyzyn@adaptec.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 00/33] SG table chaining support
Message-ID: <20070716132359.GQ5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <200707161319.l6GDJd07027464@mbox.iij4u.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707161319.l6GDJd07027464@mbox.iij4u.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16 2007, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: [PATCH 00/33] SG table chaining support
> Date: Mon, 16 Jul 2007 11:47:14 +0200
> 
> > Changes since last post:
> > 
> > - Rebase to current -git. Lots of SCSI drivers have been converted
> >   to use the sg accessor helpers, which nicely shrinks this patchset
> >   from 70 to 33 patches. Great!
> 
> ---
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] ips: sg chaining support
> 
> ips properly uses scsi_for_each_sg for the normal I/O path, however,
> the breakup path doesn't.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks, applied!

-- 
Jens Axboe

