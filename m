Return-Path: <linux-kernel-owner+w=401wt.eu-S1030669AbXDVMgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030669AbXDVMgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXDVMgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:36:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57691 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030649AbXDVMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:36:45 -0400
Date: Sun, 22 Apr 2007 13:38:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       "Cameron, Steve" <Steve.Cameron@hp.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] utilities: add helper functions for safe 64-bit integer
 operations as 32-bit halves
Message-ID: <20070422133823.4bd3eaed@the-village.bc.nu>
In-Reply-To: <20070422091816.GC1558@infradead.org>
References: <20070420114337.12a67141.akpm@linux-foundation.org>
	<1177095007.3718.43.camel@mulgrave.il.steeleye.com>
	<20070420123041.94aac1e1.akpm@linux-foundation.org>
	<1177100459.3718.45.camel@mulgrave.il.steeleye.com>
	<20070420141218.a0222472.akpm@linux-foundation.org>
	<alpine.DEB.0.98.0704201732240.11655@sigma.j-a-k-j.com>
	<alpine.DEB.0.98.0704202040150.16687@sigma.j-a-k-j.com>
	<20070421030825.bed0b8a9.akpm@linux-foundation.org>
	<20070421220147.7144113e@the-village.bc.nu>
	<20070421140622.dc197b38.akpm@linux-foundation.org>
	<20070422091816.GC1558@infradead.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > over-engineering. Call it sector_upper32() do it the simple way and stop
> > > trying to solve a problem we don't have
> > 
> > James said we have the same problem with dma_addr_t.
> 
> Yes.  It's in fact the far more common case and we have a bread of
> macros dealing with the issue in various drivers.

So we still only need it for unsigned 32/64bit values ?



Alan
