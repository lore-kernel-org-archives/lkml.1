Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbXKSNs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbXKSNs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXKSNsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:48:50 -0500
Received: from brick.kernel.dk ([87.55.233.238]:29460 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbXKSNsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:48:50 -0500
Date: Mon, 19 Nov 2007 14:46:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: alpha: fix sg_page breakage
Message-ID: <20071119134614.GH18095@kernel.dk>
References: <200711170752.lAH7qlRg003441@mbox.iij4u.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711170752.lAH7qlRg003441@mbox.iij4u.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17 2007, FUJITA Tomonori wrote:
> arch/alpha/kernel/pci-noop.c:167: warning: 'virt_to_bus' is deprecated (declared at include2/asm/io.h:117)
> arch/alpha/kernel/pci-noop.c: In function 'dma_map_sg':
> arch/alpha/kernel/pci-noop.c:183: error: 'struct scatterlist' has no member named 'page'
> arch/alpha/kernel/pci-noop.c:184: error: 'struct scatterlist' has no member named 'page'
> arch/alpha/kernel/pci-noop.c:185: warning: 'virt_to_bus' is deprecated (declared at include2/asm/io.h:11)

I'd greatly prefer this being split in two, it's really two different
changes.

-- 
Jens Axboe

