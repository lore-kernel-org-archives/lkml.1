Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0BDDVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:21:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41379
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331Ab0BDDVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:21:40 -0500
Date: Wed, 03 Feb 2010 19:21:53 -0800 (PST)
Message-Id: <20100203.192153.87354868.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com
Subject: Re: [PATCH -mm 4/4] um: remove dma_sync_single_range
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265253206-17744-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1265253206-17744-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu,  4 Feb 2010 12:13:25 +0900

> dma_sync_single_for_cpu/for_device supports a partial sync so there is
> no point to have dma_sync_single_range (also dma_sync_single was
> obsoleted long ago, replaced with dma_sync_single_for_cpu/for_device).
> 
> There is no user of dma_sync_single_range() in mainline and only Alpha
> architecture supports dma_sync_single_range(). So it's unlikely that
> someone out of the tree uses it.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: David S. Miller <davem@davemloft.net>
