Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYBRHlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYBRHlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYBRHlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:41:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34580
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753422AbYBRHlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:41:06 -0500
Date: Sun, 17 Feb 2008 23:41:42 -0800 (PST)
Message-Id: <20080217.234142.157527607.davem@davemloft.net>
To: tomof@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: more iommu sg merging fallout
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080216150341A.tomof@acm.org>
References: <20080207103801T.fujita.tomonori@lab.ntt.co.jp>
	<20080211.214036.154985035.davem@davemloft.net>
	<20080216150341A.tomof@acm.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <tomof@acm.org>
Date: Sat, 16 Feb 2008 15:03:43 +0900

> [PATCH] sparc64: make IOMMU code respect the segment boundary limits
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Looks good, but I think it will break sound for some ALI chips.

Please see arch/sparc64/kernel/pci.c:ali_sound_dma_hack()
and it's caller pci_dma_supported().

