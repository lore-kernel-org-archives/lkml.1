Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbXLEUVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbXLEUVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXLEUVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:21:37 -0500
Received: from brick.kernel.dk ([87.55.233.238]:27191 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXLEUVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:21:36 -0500
Date: Wed, 5 Dec 2007 21:21:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: use jiffies conversion functions in scsi_ioctl.c
Message-ID: <20071205202131.GF29561@kernel.dk>
References: <47561B33.3050607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47561B33.3050607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05 2007, Tejun Heo wrote:
> Use msecs_to_jiffies() and jiffies_to_msecs() in scsi_ioctl().
> Sometimes callers use very large values for e.g. vendor specific media
> clear command and calculation can overflow.

Thanks Tejun, applied.

-- 
Jens Axboe

