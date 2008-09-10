Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYIJDhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYIJDhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYIJDhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:37:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41341
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbYIJDhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:37:34 -0400
Date: Tue, 09 Sep 2008 20:37:28 -0700 (PDT)
Message-Id: <20080909.203728.135352650.davem@davemloft.net>
To: zaitcev@redhat.com
Cc: jdmason@kudzu.us, muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: Calgary and bad_dma_address
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080909211941.0a0fda6a.zaitcev@redhat.com>
References: <20080909211941.0a0fda6a.zaitcev@redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pete Zaitcev <zaitcev@redhat.com>
Date: Tue, 9 Sep 2008 21:19:41 -0600

> I was reading arch/x86/kernel/pci-calgary_64.c today, and noticed that
> apparently nothing prevents iommu_area_alloc from returning a zero.
> But bad_dma_address is zero too. Doesn't it concern anyone?
> If the first allocation asks for a page-aligned buffer to be mapped,
> a spurious bad address will result, if I understand this right.

Won't the device range reserves done by calls of calgary_reserve_mem_region()
take care of this?
