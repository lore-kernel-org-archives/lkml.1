Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbZE2I47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbZE2I47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZE2I4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:56:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36752
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbZE2I4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:56:47 -0400
Date: Fri, 29 May 2009 01:56:47 -0700 (PDT)
Message-Id: <20090529.015647.51443277.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30 1/2] cxgb3: fix dma mapping regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090528212302.28149.46684.stgit@speedy5>
References: <20090528212302.28149.46684.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Thu, 28 May 2009 14:23:02 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Commit 5e68b772e6efd189d6aca76f6872fb75d51ace60
>   cxgb3: map entire Rx page, feed map+offset to Rx ring.
> 
> introduced a regression on platforms defining DECLARE_PCI_UNMAP_ADDR()
> and related macros as no-ops.
> 
> Rx descriptors are fed with the a page buffer bus address + page chunk offset.
> The page buffer bus address is set and retrieved through
> pci_unamp_addr_set(), pci_unmap_addr().
> These functions being meaningless on x86 (if CONFIG_DMA_API_DEBUG is not set).
> The HW ends up with a bogus bus address.
> 
> This patch saves the page buffer bus address for all plaftorms.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
