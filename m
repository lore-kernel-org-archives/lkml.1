Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZGGBLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZGGBLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 21:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZGGBLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 21:11:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32978
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZGGBLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 21:11:24 -0400
Date: Mon, 06 Jul 2009 18:11:31 -0700 (PDT)
Message-Id: <20090706.181131.92078657.davem@davemloft.net>
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, reif@earthlink.net
Subject: Re: [PATCH 2/5] sparc: use asm-generic/dma-mapping-common.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907061026.28878.arnd@arndb.de>
References: <1246860820-20629-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1246860820-20629-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<200907061026.28878.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 6 Jul 2009 10:26:28 +0200

> On Monday 06 July 2009, FUJITA Tomonori wrote:
>> +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
>> +{
>> +       return dma_ops;
>> +}
>> +
>> +#define flush_write_buffers()
>> +
>> +#include <asm-generic/dma-mapping-common.h>
> 
> I still think the flush_write_buffers() x86-ism should not be required
> to use dma-mapping-common.h and only be used in arch/x86/kernel/pci-nommu.c
> so you don't have to add dummy definitions to all architectures.
> 
> See http://lkml.org/lkml/2009/6/30/134
> 
> Otherwise, your series looks good!

Since we have until the 2.6.32 merge window to merge this, why
don't we take care of this flush_write_buffers() thing first?

I'm completely fine with these changes otherwise, thanks!
