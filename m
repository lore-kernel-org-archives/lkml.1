Return-Path: <linux-kernel-owner+w=401wt.eu-S1761535AbYFBN4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535AbYFBN4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYFBN4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:56:30 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6327 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbYFBN43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:56:29 -0400
X-BigFish: VPS-39(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K1U9DF-02-AF5-01
Date: Mon, 2 Jun 2008 15:56:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: Add PCI extended config space access for AMD
	Barcelona
Message-ID: <20080602135603.GG23679@erda.amd.com>
References: <20080526180616.GB2752@erda.amd.com> <20080528165813.8D8E5814C@erda.amd.com> <20080602090947.GA22060@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080602090947.GA22060@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 02 Jun 2008 13:56:04.0643 (UTC) FILETIME=[661F8F30:01C8C4B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.06.08 11:09:47, Ingo Molnar wrote:
> diff --git a/include/asm-x86/mmconfig.h b/include/asm-x86/mmconfig.h
> index 95beda0..46d6bb1 100644
> --- a/include/asm-x86/mmconfig.h
> +++ b/include/asm-x86/mmconfig.h
> @@ -9,4 +9,6 @@ static inline void fam10h_check_enable_mmcfg(void) { }
>  static inline void check_enable_amd_mmconf_dmi(void) { }
>  #endif
>  
> +extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
> +
>  #endif

It's better to add #include "../setup.h" to arch/x86/kernel/cpu/amd_64.c
since this is already defined there and it is actually no mmconf code.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

