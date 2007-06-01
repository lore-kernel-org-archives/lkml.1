Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbXFAVbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbXFAVbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbXFAVbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:31:41 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3248 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162AbXFAVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:31:40 -0400
Date: Fri, 1 Jun 2007 22:31:30 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Maximus <john.maximus@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dma_alloc_coherent fails
Message-ID: <20070601213129.GC5400@flint.arm.linux.org.uk>
Mail-Followup-To: Maximus <john.maximus@gmail.com>,
	linux-kernel@vger.kernel.org
References: <3634de740706010946iabd6c51rf7e9a36463e3fca3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3634de740706010946iabd6c51rf7e9a36463e3fca3@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 10:16:41PM +0530, Maximus wrote:
> Hi,
> Am using a linux 2.6.19 kernel for arm. the dma_alloc_coherent
> function call in the kernel for 38400 bytes fails.
> 
> Has anyone faced this problem before?.
> 
> What could be make dma_alloc_coherent to success sometimes and fail 
> sometimes?.

Memory fragmentation.  Large allocations (> 1 page) are always unreliable.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
