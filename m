Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbXKSPDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbXKSPDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbXKSPDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:03:40 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34484 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbXKSPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:03:39 -0500
Message-ID: <4741A5BC.4080004@davidnewall.com>
Date: Tue, 20 Nov 2007 01:33:24 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: DMA4 reserved for cascade
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There seems something too-specific to PC-architecture in kernel/dma.c, 
which is that DMA4 is reserved for "cascade".  Perhaps it should be 
reserved in architecture-specific initialisation.  What do other 
architectures do with that?
