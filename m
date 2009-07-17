Return-Path: <linux-kernel-owner+w=401wt.eu-S934036AbZGQChb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbZGQChb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934037AbZGQCha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:37:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60125
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934031AbZGQCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:37:28 -0400
Date: Thu, 16 Jul 2009 19:37:33 -0700 (PDT)
Message-Id: <20090716.193733.64064398.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 5/8] sparc: remove no-op dma_4v_sync_single_for_cpu and
 dma_4v_sync_sg_for_cpu
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247466360-13330-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1247466360-13330-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 13 Jul 2009 15:25:57 +0900

> Now sparc uses include/asm-generic/dma-mapping-common.h. pci_sun4v.c
> doesn't need to have no-op dma_4v_sync_single_for_cpu and
> dma_4v_sync_sg_for_cpu (dma-mapping-common.h does nothing if
> sync_{single|sg}_for_cpu hook is not defined). So we can remove them
> safely.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Tested-by: Robert Reif <reif@earthlink.net>

ACK
