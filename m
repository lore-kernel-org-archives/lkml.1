Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYKUQzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYKUQzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYKUQzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:55:02 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYKUQzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:55:01 -0500
Subject: Re: [PATCH 0/10] DMA-API debugging facility
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 16:54:52 +0000
Message-Id: <1227286492.4901.208.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 17:26 +0100, Joerg Roedel wrote:
> this patchset introduces code to debug drivers usage of the DMA-API.
> Tests with hardware IOMMUs have shown several bugs in drivers
> regarding the usage of that API.
> Problems were found especially in network card drivers.

This is really useful -- but surely it shouldn't be x86-specific?

All the code except the hooks in the architecture's dma_map_single() et
al functions could be generic, couldn't it?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

