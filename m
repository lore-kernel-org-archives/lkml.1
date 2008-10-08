Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYJHWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYJHWDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYJHWDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:03:03 -0400
Received: from khc.piap.pl ([195.187.100.11]:56556 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbYJHWDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:03:02 -0400
To: "Hillier\, Gernot" <gernot.hillier@siemens.com>
Cc: jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bruce.w.allan@intel.com
Subject: Re: e1000e: sporadic "hardware error"s with Intel 82563EB on Supermicro X7DB3
References: <48EB7161.60004@siemens.com> <m33aj78jnh.fsf@maximus.localdomain>
	<48ECB727.6050905@siemens.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 09 Oct 2008 00:03:00 +0200
In-Reply-To: <48ECB727.6050905@siemens.com> (Gernot Hillier's message of "Wed\, 08 Oct 2008 15\:35\:35 +0200")
Message-ID: <m31vyq923v.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hillier, Gernot" <gernot.hillier@siemens.com> writes:

>         Region 0: Memory at d0020000 (32-bit, non-prefetchable) [size=128K]
>         Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=128K]
>         Region 2: I/O ports at 4000 [size=32]
>         [virtual] Expansion ROM at d0080000 [disabled] [size=64K]

Doesn't look like a spurious reset, though.

> - Control "DisINTx-" changes to "DisINTx+" if the card is correctly
> initialized
> - Interrupt changes from IRQ 18 to IRQ 4345 if card is correctly initialized
> - Message Signalled Interrupts change from "Enable-" to "Enable+"

The "normal" effects of enabling MSI.
-- 
Krzysztof Halasa
