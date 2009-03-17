Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZCQHpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZCQHpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZCQHpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:45:07 -0400
Received: from 8bytes.org ([88.198.83.132]:51648 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbZCQHpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:45:06 -0400
Date: Tue, 17 Mar 2009 08:45:02 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mcgrof@gmail.com, iommu@lists.linux-foundation.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AMD Quad core - PCI-DMA: Out of IOMMU space on > 4 GB RAM
Message-ID: <20090317074501.GQ2125@8bytes.org>
References: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com> <20090317093445G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317093445G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 09:35:45AM +0900, FUJITA Tomonori wrote:
> From a quick look, ath9k doesn't call pci_unmap_single for rx
> buffers. Though I might be wrong because I don't know anything about
> the driver.

In any case. This error description sounds very much like a dma memory
leak on module unload. So its very likely a driver issue.

Joerg

