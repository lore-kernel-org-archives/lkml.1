Return-Path: <linux-kernel-owner+w=401wt.eu-S1765625AbXG0I1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765625AbXG0I1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 04:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXG0I1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 04:27:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:41388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbXG0I1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 04:27:39 -0400
In-Reply-To: <11854393721520-git-send-email-wei.zhang@freescale.com>
References: <11854393721520-git-send-email-wei.zhang@freescale.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <45F59724-0FE8-4FE1-B663-ECF58F812B30@kernel.crashing.org>
Cc: mporter@kernel.crashing.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 0/5 v3] Porting RapidIO driver from ppc to powerpc architecture and adding memory mapped RapidIO driver.
Date: Fri, 27 Jul 2007 03:28:26 -0500
To: Zhang Wei <wei.zhang@freescale.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26, 2007, at 3:42 AM, Zhang Wei wrote:

> These patches are the version 3 patches for RapidIO with dts update  
> and some minor fixups.
>
> These patches are used for supporting RapidIO controllers of  
> Freescale. I ported them from ppc architecture to powerpc  
> architecture and added some new features, such as memory mapped  
> driver.
>
> [PATCH 1/5] Add the explanation and sample of RapidIO DTS OF-node  
> to the document of booting-without-of.txt file.
> [PATCH 2/5] Add RapidIO OF-node to MPC8641HPCN board dts file.
> [PATCH 3/5] Add the platform device support with RapidIO to  
> MPC8641HPCN platform.
> [PATCH 4/5] Add RapidIO support to powerpc architecture.
> [PATCH 5/5] Add the memory management driver to RapidIO.
>
> Please see below descriptions of these patches:
> 1. Add the RapidIO driver of-device support.
> 2. Add the RapidIO driver support to MPC8641HPCN board.
> 3. Port the RapidIO from ppc to powerpc architecture.

Can we do the port from ppc as follows:
- cp arch/ppc/syslib/*85xx*rio to arch/powerpc/syslib/fsl_rio.{c,h}  
make everything still build
- rename cleanup the code in fsl_rio.{c,h}

this makes it easier to see what changes actually are to fsl_rio.{c,h}

> 4. Add Memory mapped RapidIO driver.
> 5. Add the support to multi master ports.
> 6. Add a simple bitmap RapidIO space allocator driver.
> 7. Change the RapidIO system size of menuconfig to automatically  
> detection.

also you describe 7 items, was expect 7 patches :)

- k
