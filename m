Return-Path: <linux-kernel-owner+w=401wt.eu-S966684AbXEGUfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966684AbXEGUfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966669AbXEGUfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:35:15 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:53677 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966681AbXEGUfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:35:13 -0400
Date: Mon, 07 May 2007 13:35:08 -0700
From: Johnnie Peters <johnnie123@verizon.net>
Subject: Problems with DMA in the pxa2xx_spi driver
To: linux-kernel@vger.kernel.org
Message-id: <463F8D7C.4080304@verizon.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have written a SPI protocol driver to connect a data acquisition chip 
to a character based interface to read and write the device.  It works 
well in PIO mode and I am trying to get it to work with DMA.

To enable the DMA I am setting enable_dma in the pxa2xx_psi_chip struct 
and dma_burst_size to 16 in the pxa2xx_spi_chip structure under the 
board master file arch/arm/mach-pxa/xxxx.c.

Other than that I have not really changed anything.  I had assumed since 
DMA code has been in the driver a while that DMA would just work.  I 
must be missing some setup data I need.

Any help would be appreciated,

Johnnie


