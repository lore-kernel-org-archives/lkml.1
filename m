Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0CIJOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:14:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51018 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0CIJOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:14:22 -0500
Date: Tue, 9 Mar 2010 09:14:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lin Mac <mkl0301@gmail.com>
Cc: Thomas Koeller <thomas@koeller.dyndns.org>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: DMA using data buffer vmapped in kernel space
Message-ID: <20100309091403.GB5691@n2100.arm.linux.org.uk>
References: <201003042211.28569.thomas@koeller.dyndns.org> <20100304213634.GH13417@n2100.arm.linux.org.uk> <201003061407.12698.thomas@koeller.dyndns.org> <20100306193127.GA13262@n2100.arm.linux.org.uk> <10d816431003082345j5438d8cdi8ad72c4fa296b684@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10d816431003082345j5438d8cdi8ad72c4fa296b684@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 03:45:54PM +0800, Lin Mac wrote:
> I had encounter a similiar problem and I simply allocated a new
> buffer, copy the data, then DMA. It seems slow and stupid.
> 
> I'm wondering wether could I translate the vmap virt to phys(don't
> know how to yet), then use phys_to_virt to get the virt in
> direct-mapped memory region?
> 
> Is there other possible ways?

I think you need to talk to the firmware people... which is unfortunately
orphaned.

What you could do is prepare a patch to allow the firmware support to
export a scatterlist via the struct firmware, and then use that with
dma_map_sg().  Let's hope that the SPI interfaces support scatterlists.
