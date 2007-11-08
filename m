Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbXKHUQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbXKHUQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762469AbXKHUPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:15:53 -0500
Received: from brick.kernel.dk ([87.55.233.238]:13403 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762260AbXKHUPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:15:50 -0500
Date: Thu, 8 Nov 2007 21:15:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       btrace <linux-btrace@vger.kernel.org>
Subject: Re: [PATCH] Add UNPLUG traces to all appropriate places
Message-ID: <20071108201544.GB13741@kernel.dk>
References: <473319F3.30706@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473319F3.30706@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08 2007, Alan D. Brunelle wrote:
> Added blk_unplug interface, allowing all invocations of unplugs to result
> in a generated blktrace UNPLUG. Previously, we saw a PLUG on each of the
> underlying devices, and an UNPLUG on the volume. This patch ensures that
> we see the UNPLUG calls for each of the underlying devices.

Looks fine Alan, applied.

-- 
Jens Axboe

