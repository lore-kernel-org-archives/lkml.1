Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYCQUfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYCQUfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbYCQUe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:34:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:57672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbYCQUe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:34:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,514,1199692800"; 
   d="scan'208";a="356197104"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] pasemi_dma: Driver for PA Semi PWRficient on-chip DMAengine
Date: Mon, 17 Mar 2008 13:34:05 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C043E6716@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080316213002.GA2589@lixom.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] pasemi_dma: Driver for PA Semi PWRficient on-chip DMAengine
thread-index: AciHq+pqjGltKl/ASNaiT3KpOsdc5gAtKaoQ
References: <20080306233900.GA3969@lixom.net> <20080316213002.GA2589@lixom.net>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Olof Johansson" <olof@lixom.net>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <pasemi-linux@ozlabs.org>,
       <linuxppc-dev@ozlabs.org>, <hskinnemoen@atmel.com>
X-OriginalArrivalTime: 17 Mar 2008 20:34:05.0721 (UTC) FILETIME=[3E8C2090:01C8886E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Olof Johansson [mailto:olof@lixom.net] 
>Sent: Sunday, March 16, 2008 2:30 PM
>
>pasemi_dma: Driver for PA Semi PWRficient on-chip DMA engine
>
>DMA copy offload driver for PA Semi PWRficient. It uses the
>platform-specific functions to allocate channels, etc.
>
>Signed-off-by: Olof Johansson <olof@lixom.net>
>
>---
>
>Changes since last post:
>
>* Add DMA_INTERRUPT support and handling of the interrupt flag
>* Fix interrupt handler for above and add tasklet
>* Switch to spin_lock_bh() where possible
>* Remove empty dependency_added() function since it's no longer
>  used in the framework.
>* Fix bug in "ring full" estimation.
>
>Note that this still needs to go on top of the powerpc.git 
>tree due to the
>pasemi_dma.h updates that this driver depends on. I suggest 
>merging this
>through pasemi.git->powerpc.git->linus with an Acked-by from 
>the DMA guys.

Hi Olof,

In the future please copy Maciej as one of "the DMA guys" as he has
taken over ioatdma for me.  Beyond that, one little picky comment
below...


>
>
>-Olof
>
> [...]
> 
>+
>+static unsigned int channels = 4;
>+module_param(channels, uint, S_IRUGO);
>+MODULE_PARM_DESC(channels, "Number of channels for copy 
>(default: 2)");

Is the number of channels defaulting to 2 or 4?

sln

