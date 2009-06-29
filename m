Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZF2TU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZF2TU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZF2TUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:20:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:17997 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbZF2TUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:20:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,311,1243839600"; 
   d="scan'208";a="470584988"
Date: Mon, 29 Jun 2009 12:20:21 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Fernando Luis =?UTF-8?B?VsOhenF1ZXo=?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: akpm@linux-foundation.org, jbeulich@novell.com, gregkh@suse.de,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Subject: Re: [PATCH] PCI: remove pci_dac_dma_... APIs on mn10300
Message-ID: <20090629122021.1c2b01fa@jbarnes-g45>
In-Reply-To: <4A44321D.3070007@oss.ntt.co.jp>
References: <1228367335.10823.22.camel@sebastian.kern.oss.ntt.co.jp>
	<4A4431D9.10906@oss.ntt.co.jp>
	<4A44321D.3070007@oss.ntt.co.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 11:27:41 +0900
Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> wrote:

> It seems that mn10300 made it upstream after Jan Beulich's
> pci_dac_dma_* cleanup work and still defines pci_dac_dma_supported().
> This API is not required by the PCI subsystem anymore, so remove it.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.31-rc1-orig/arch/mn10300/include/asm/pci.h
> linux-2.6.31-rc1/arch/mn10300/include/asm/pci.h ---
> linux-2.6.31-rc1-orig/arch/mn10300/include/asm/pci.h
> 2009-06-26 10:58:02.012044068 +0900 +++
> linux-2.6.31-rc1/arch/mn10300/include/asm/pci.h	2009-06-26
> 11:19:34.130867667 +0900 @@ -70,10 +70,6 @@ struct pci_dev; */
> #define PCI_DMA_BUS_IS_PHYS	(1)
> 
> -
> -/* This is always fine. */
> -#define pci_dac_dma_supported(pci_dev, mask)	(0)
> -
>   /* Return the index of the PCI controller for device. */
>   static inline int pci_controller_num(struct pci_dev *dev)
>   {

Had to fix up some fuzz, but it's now in my for-linus branch.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
