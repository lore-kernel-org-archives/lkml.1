Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYD0Kfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYD0Kfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYD0Kfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:35:42 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27918 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYD0Kfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:35:41 -0400
Date: Sun, 27 Apr 2008 12:35:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH] ps3disk: Remove superfluous cast
Message-ID: <20080427103534.GU12774@kernel.dk>
References: <Pine.LNX.4.64.0804231357170.13313@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804231357170.13313@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23 2008, Geert Uytterhoeven wrote:
> As ps3disk is a ppc64-only driver, sector_t equals to unsigned long, and the
> cast is not needed.
> 
> Reuse in another (possibly 32-bit) driver is protected by the safety net called
> `compiler warning' (with the cast, it may silently truncate to 32-bit).
> If sector_t ever changes, we will get a compiler warning as well (with the
> cast, we won't).
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Acked-by: Christoph Hellwig <hch@lst.de>
> ---
> Please apply, thx!

Applied

-- 
Jens Axboe

