Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXLLHbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXLLHbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 02:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXLLHbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 02:31:04 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9244 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbXLLHbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 02:31:03 -0500
Date: Wed, 12 Dec 2007 08:27:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: use jiffies conversion functions in scsi_ioctl.c
Message-ID: <20071212072738.GB4975@kernel.dk>
References: <47561B33.3050607@gmail.com> <20071205202131.GF29561@kernel.dk> <475F5432.6020405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475F5432.6020405@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12 2007, Tejun Heo wrote:
> Jens Axboe wrote:
> > On Wed, Dec 05 2007, Tejun Heo wrote:
> >> Use msecs_to_jiffies() and jiffies_to_msecs() in scsi_ioctl().
> >> Sometimes callers use very large values for e.g. vendor specific media
> >> clear command and calculation can overflow.
> > 
> > Thanks Tejun, applied.
> 
> Jens, it seems premature timeout on bug 9346 could be caused by the same
> problem.  Can you push this so that it can go into 2.6.24?

Certainly, it'll go in for 2.6.24. I'll push it out today.

-- 
Jens Axboe

