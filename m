Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbYCZLNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbYCZLNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbYCZLNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:13:15 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18703 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbYCZLNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:13:15 -0400
Date: Wed, 26 Mar 2008 12:13:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CDROM: use kmalloced buffers instead of buffers on stack
Message-ID: <20080326111310.GC15355@kernel.dk>
References: <20080323111532.19DBFC2DFF@solo.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323111532.19DBFC2DFF@solo.franken.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23 2008, Thomas Bogendoerfer wrote:
> If cdrom commands are issued to a scsi drive in most cases the buffer
> will be filled via dma. This leads to bad stack corruption on non coherent
> platforms, because the buffers are neither cache line aligned nor is
> the size a multiple of the cache line size. Using kmalloced buffers
> avoids this.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thanks Thomas, applied.

-- 
Jens Axboe

