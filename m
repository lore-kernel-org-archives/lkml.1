Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXBIV26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXBIV26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXBIV26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:28:58 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:36975 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbXBIV25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:28:57 -0500
Date: Fri, 9 Feb 2007 16:28:56 -0500
To: Raphael Assenat <raph@8d.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add PCI device ID for IT8152 RISC-to-PCI chip
Message-ID: <20070209212856.GK7584@csclub.uwaterloo.ca>
References: <45CCD60D.5050001@8d.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CCD60D.5050001@8d.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 03:14:05PM -0500, Raphael Assenat wrote:
> This patch adds a PCI device ID (0x8152) for the IT8152F/G
> Advanced RISC-to-PCI Companion Chip.
> 
> -- 
> Raphael Assenat
> 8D Technologies Inc.

> This patch adds a PCI device ID for the IT8152F/G 
> Advanced RISC-to-PCI Companion Chip.
> 
> Signed-off-by: Raphael Assenat <raph@8d.com>
> 
> --- linux-2.6.20/include/linux/pci_ids.h	2007-02-04 13:44:54.000000000 -0500
> +++ linux-2.6.20-8d/include/linux/pci_ids.h	2007-02-09 15:00:38.000000000 -0500
> @@ -1626,6 +1626,7 @@
>  #define PCI_VENDOR_ID_ROCKWELL		0x127A
>  
>  #define PCI_VENDOR_ID_ITE		0x1283
> +#define PCI_DEVICE_ID_ITE_8152		0x8152
>  #define PCI_DEVICE_ID_ITE_8211		0x8211
>  #define PCI_DEVICE_ID_ITE_8212		0x8212
>  #define PCI_DEVICE_ID_ITE_8872		0x8872

Oh that one.  Anyone ever have a reliable PCI bus with one of these?
The one system on a board I have worked with in the past had so many
problems with the PCI bus that we have to switch to another board
instead.  Too bad since the ARM cpu was much faster and better and
handling network traffic (we switched to a Geode SC1200 based board).

At the time my theory was that the cpu would interrupt DMA transfers
when it wanted access to system memory, which would break the PCI
transfers.  But that was just my theory.

--
Len Sorensen
