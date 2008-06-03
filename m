Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYFCR6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYFCR6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbYFCR5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:57:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:14901 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbYFCR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=iL/fGPNaZm6zCt/ua5JdjJYUw8wllGPFN5YKEjz5e2EVSn0ATlNKwXrQjwRRnQAwAXCQ2kxP0EiUeprD1zgLinVMgg0va3KlRQvCC85635ZP84HI6rp6ThAQyiySh5sgUMfBxVlO6EAC+kS6KYj10/2gYBTroWGq87YWBu09NYs=
Date: Tue, 3 Jun 2008 19:57:10 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jon Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: mv DMA-* to separate DMA/ subdirectory
Message-ID: <20080603175302.GA5910@joi>
References: <20080602195439.GA27583@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602195439.GA27583@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 03:54:39PM -0400, J. Bruce Fields wrote:
> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> Every now and then as I'm looking for something in Documentation/ I get
> annoyed at how cluttered that directory is, and go look for a few files
> that could be grouped into a subdirectory.  This seemed like one
> candidate, though a lot of referenes to DMA-mapping.txt require fixing.
> 
> Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
> ---
> 
> A Documentation/arch directory would take out another dozen entries or
> so, but I haven't had the energy.--b.
> 
>  Documentation/00-INDEX               |    4 -
>  Documentation/DMA-API.txt            |  614 ---------------------------
>  Documentation/DMA-ISA-LPC.txt        |  151 -------
>  Documentation/DMA-attributes.txt     |   24 -
>  Documentation/DMA-mapping.txt        |  766 ----------------------------------
>  Documentation/DMA/00-INDEX           |   10 +
>  Documentation/DMA/DMA-API.txt        |  614 +++++++++++++++++++++++++++
>  Documentation/DMA/DMA-ISA-LPC.txt    |  151 +++++++
>  Documentation/DMA/DMA-attributes.txt |   24 +
>  Documentation/DMA/DMA-mapping.txt    |  766 ++++++++++++++++++++++++++++++++++
>  Documentation/IO-mapping.txt         |    2 +-
>  Documentation/PCI/pci.txt            |    6 +-
>  Documentation/block/biodoc.txt       |    5 +-
>  Documentation/memory-barriers.txt    |    2 +-
>  Documentation/usb/dma.txt            |   13 +-
>  arch/ia64/hp/common/sba_iommu.c      |   12 +-
>  arch/ia64/sn/pci/pci_dma.c           |    4 +-
>  arch/parisc/kernel/pci-dma.c         |    2 +-
>  arch/x86/kernel/pci-gart_64.c        |    2 +-
>  drivers/net/tehuti.c                 |    2 +-
>  drivers/parisc/sba_iommu.c           |   18 +-
>  include/asm-ia64/dma-mapping.h       |    2 +-
>  include/asm-parisc/dma-mapping.h     |    2 +-
>  include/asm-x86/dma-mapping.h        |    2 +-
>  include/linux/dma-attrs.h            |    2 +-
>  include/media/videobuf-dma-sg.h      |    2 +-
>  26 files changed, 1605 insertions(+), 1597 deletions(-)
>  delete mode 100644 Documentation/DMA-API.txt
>  delete mode 100644 Documentation/DMA-ISA-LPC.txt
>  delete mode 100644 Documentation/DMA-attributes.txt
>  delete mode 100644 Documentation/DMA-mapping.txt
>  create mode 100644 Documentation/DMA/00-INDEX
>  create mode 100644 Documentation/DMA/DMA-API.txt
>  create mode 100644 Documentation/DMA/DMA-ISA-LPC.txt
>  create mode 100644 Documentation/DMA/DMA-attributes.txt
>  create mode 100644 Documentation/DMA/DMA-mapping.txt

Maybe drop DMA- prefix? It's useless now.

Marcin
