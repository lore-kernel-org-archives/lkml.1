Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0CBNzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:55:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53249
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056Ab0CBNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:55:16 -0500
Date: Tue, 02 Mar 2010 05:55:34 -0800 (PST)
Message-Id: <20100302.055534.115500087.davem@davemloft.net>
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <201003021454.12125.arnd@arndb.de>
References: <201003021438.32144.arnd@arndb.de>
	<20100302224858G.fujita.tomonori@lab.ntt.co.jp>
	<201003021454.12125.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 2 Mar 2010 14:54:11 +0100

> Broken in the sense that arch/powerpc/Kconfig describes CONFIG_IOMMU_VMERGE:
> 
>        Cause IO segments sent to a device for DMA to be merged virtually
>        by the IOMMU when they happen to have been allocated contiguously.
>        This doesn't add pressure to the IOMMU allocator. However, some
>        drivers don't support getting large merged segments coming back
>        from *_map_sg().
> 
>        Most drivers don't have this problem; it is safe to say Y here.
> 
> I don't know if this comment still applies to any drivers in the mainline
> kernel, but it's possible.

That really has to be out of date these days.
