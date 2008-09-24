Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYIXSa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYIXSa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIXSau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:30:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:45189 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYIXSat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:30:49 -0400
Cc: Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>,
       zw@zh-kernel.org, linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-Id: <47B7FAA6-434C-440A-B55D-03C9882809CE@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <1221837088-19539-1-git-send-email-timur@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module
Date: Wed, 24 Sep 2008 13:30:27 -0500
References: <1221837088-19539-1-git-send-email-timur@freescale.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 19, 2008, at 10:11 AM, Timur Tabi wrote:

> Modify the Freescale Elo / Elo Plus DMA driver so that it can be  
> compiled as
> a module.
>
> The primary change is to stop treating the DMA controller as a bus,  
> and the
> DMA channels as devices on the bus.  This is because the Open  
> Firmware (OF)
> kernel code does not allow busses to be removed, so although we can  
> call
> of_platform_bus_probe() to probe the DMA channels, there is no
> of_platform_bus_remove().  Therefore, the DMA channels must be  
> manually probed.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>
> (Reposting because I forgot to CC: the maintainers)
>
> This patch is for the 2.6.28 kernel.  This patch exposes a bug in  
> the dmatest
> module, so my other patch "dmatest: properly handle duplicate DMA  
> channels"
> should be applied if this patch is applied.
>
> drivers/dma/Kconfig  |   10 ++--
> drivers/dma/fsldma.c |  165 +++++++++++++++++++++++++++++++++ 
> +----------------
> drivers/dma/fsldma.h |    2 +
> 3 files changed, 119 insertions(+), 58 deletions(-)

Dan, any update on this patch?

- k
