Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbXERMam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbXERMam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXERMaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:30:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36303 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754370AbXERMaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:30:35 -0400
Date: Fri, 18 May 2007 13:34:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Zoltan Boszormenyi <zboszor@dunaweb.hu>, Peer Chen <pchen@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
Message-ID: <20070518133456.5f1392e9@the-village.bc.nu>
In-Reply-To: <464D0855.20703@shaw.ca>
References: <fa.iernIz8Xcuvw0SBwi4A99Ju0g2o@ifi.uio.no>
	<464D0855.20703@shaw.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That shouldn't be a problem, libata default DMA mask is 32 bits (which 
> isn't overridden with this controller) and so the block layer will 
> bounce any data being read/written above that point with IOMMU or 
> swiotlb. The comment is a bit unnecessarily scary.

Adding a BUG_ON for this would be wise. Its trivial to check and a BUG
rather than corruption if this assumption ever changes would be far
preferable
