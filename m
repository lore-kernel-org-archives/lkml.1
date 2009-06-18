Return-Path: <linux-kernel-owner+w=401wt.eu-S1764036AbZFROHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764036AbZFROHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763456AbZFROHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:07:20 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:48077 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763520AbZFROHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:07:18 -0400
Message-ID: <4A3A4A16.6080307@snapgear.com>
Date: Fri, 19 Jun 2009 00:07:18 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, gerg@uclinux.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] m68k: merge the non-mmu and mmu versions of hardirq.h
References: <200906170710.n5H7AxxV009015@localhost.localdomain> <200906170941.44383.arnd@arndb.de>
In-Reply-To: <200906170941.44383.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnd,

Arnd Bergmann wrote:
> On Wednesday 17 June 2009, Greg Ungerer wrote:
>> [PATCH] m68k: merge the non-mmu and mmu versions of hardirq.h
>>
>> There is nothing different required between the non-mmu and mmu
>> versions of hardirq.h, so merge them back into a single file.
>>
>> Signed-off-by: Greg Ungerer <gerg@uclinux.org>
> 
> AFAICT this file is also the same in the new asm-generic version, so you
> could fall back to that directly.

Indeed it could. It will need a clean out of ack_bad_irq() in
arch/m68knommu/kernel.irq.c, but otherwise looks good.

I'll prepare a new patch that uses that.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
