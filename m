Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbZGQChn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbZGQChn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934001AbZGQChm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:37:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60131
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934010AbZGQChl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:37:41 -0400
Date: Thu, 16 Jul 2009 19:37:46 -0700 (PDT)
Message-Id: <20090716.193746.160720785.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 6/8] sparc: replace sbus_map_single and
 sbus_unmap_single with sbus_map_page and sbus_unmap_page
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247466360-13330-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1247466360-13330-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 13 Jul 2009 15:25:58 +0900

> This is a preparation for using asm-generic/pci-dma-compat.h; SPARC32
> has two dma_map_ops structures for pci and sbus (removing
> arch/sparc/kernel/dma.c, PCI and SBUS DMA accessor).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Tested-by: Robert Reif <reif@earthlink.net>

ACK
