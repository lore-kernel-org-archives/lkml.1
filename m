Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXEROez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXEROez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXEROes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:34:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49101 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321AbXEROer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:34:47 -0400
Message-ID: <464DB97B.8030204@garzik.org>
Date: Fri, 18 May 2007 10:34:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Robert Hancock <hancockr@shaw.ca>, Zoltan Boszormenyi <zboszor@dunaweb.hu>,
       Peer Chen <pchen@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
References: <fa.iernIz8Xcuvw0SBwi4A99Ju0g2o@ifi.uio.no>	<464D0855.20703@shaw.ca> <20070518133456.5f1392e9@the-village.bc.nu>
In-Reply-To: <20070518133456.5f1392e9@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> That shouldn't be a problem, libata default DMA mask is 32 bits (which 
>> isn't overridden with this controller) and so the block layer will 
>> bounce any data being read/written above that point with IOMMU or 
>> swiotlb. The comment is a bit unnecessarily scary.
> 
> Adding a BUG_ON for this would be wise. Its trivial to check and a BUG
> rather than corruption if this assumption ever changes would be far
> preferable

The default DMA mask -everywhere- is 32 bits.

A lot of code will break if this assumption ever changes, not just libata.

	Jeff



