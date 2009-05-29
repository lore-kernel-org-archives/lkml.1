Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZE2Iv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZE2Iv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZE2Ivu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:51:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49217
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbZE2Ivt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:51:49 -0400
Date: Fri, 29 May 2009 01:51:49 -0700 (PDT)
Message-Id: <20090529.015149.92225019.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] net: replace dma_sync_single with
 dma_sync_single_for_cpu
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090528100925H.fujita.tomonori@lab.ntt.co.jp>
References: <20090528100925H.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 28 May 2009 10:10:42 +0900

> This replaces dma_sync_single() with dma_sync_single_for_cpu() because
> dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:
> 
> /* Backwards compat, remove in 2.7.x */
> #define dma_sync_single		dma_sync_single_for_cpu
> #define dma_sync_sg		dma_sync_sg_for_cpu
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Applied to net-next-2.6, thank you.
