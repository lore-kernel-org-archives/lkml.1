Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0BMBJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:09:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48465
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755695Ab0BMBJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:09:33 -0500
Date: Fri, 12 Feb 2010 17:09:48 -0800 (PST)
Message-Id: <20100212.170948.62243103.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -mm 1/7] sparc: unify 32bit and 64bit dma_set_mask
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265967212-9126-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1265967212-9126-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 12 Feb 2010 18:33:26 +0900

> sparc has two dma_set_mask implementations for 32bit and 64bit. They
> are same except for the error returned value. We can safely unify them
> since the error returned value doesn't matter as long as it is
> negative (as DMA-API.txt describes).
> 
> This patch also changes dma_set_mask not to call
> pci_set_dma_mask. Instead, dma_set_mask does the same thing that
> pci_set_dma_mask does. This change enables ut to change
> pci_set_dma_mask to call dma_set_mask; we can implement
> pci_set_dma_mask as pci-dma-compat.h does.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: David S. Miller <davem@davemloft.net>
