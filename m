Return-Path: <linux-kernel-owner+w=401wt.eu-S933733AbXJQLM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733AbXJQLM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbXJQLMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:12:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8186 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbXJQLMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:12:15 -0400
Date: Wed, 17 Oct 2007 13:11:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Message-ID: <20071017111146.GW5043@kernel.dk>
References: <20071017.035441.74746708.davem@davemloft.net> <20071017105840.GT5043@kernel.dk> <20071017110142.GU5043@kernel.dk> <20071017.041004.21594558.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017.041004.21594558.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, 17 Oct 2007 13:01:42 +0200
> 
> > Actually, just clearing AFTER sg_next() would be fine, since we know
> > that is not a link entry. Duh...
> 
> Yes and I'm running a kernel successfully with this fix.

Great!

> Jens, please also add the following on top of Fujita-san's most recent
> sparc64 patch and we should be good to go.

Awesome, thanks. And sorry for messing up sparc64.

-- 
Jens Axboe

