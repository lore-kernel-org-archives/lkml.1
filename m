Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZF3Mit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZF3Mit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZF3Mil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:38:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47137 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752497AbZF3Mil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:38:41 -0400
Date: Tue, 30 Jun 2009 13:40:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
 in dma_sync_*_for_cpu
Message-ID: <20090630134000.23674147@lxorguk.ukuu.org.uk>
In-Reply-To: <200906301434.26815.arnd@arndb.de>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	<200906291845.16335.arnd@arndb.de>
	<20090629181603.079f32f1@lxorguk.ukuu.org.uk>
	<200906301434.26815.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok. The Winchip also does not have an IOMMU or the need for SWIOTLB, so
> I guess it would be ok to move the flush_write_buffers() out of the common
> code into the x86 pci-nommu implementation. That one is also the only
> place that calls flush_write_buffers() in dma_map_().

What about non x86 - this is asm-generic you are playing with and its the
kind of change that causes evil really hard to track down and subtle
corruptions and user data loss if you get it wrong.

