Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbYBMQL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbYBMQL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYBMQLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:11:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:60659 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYBMQLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:11:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,347,1199692800"; 
   d="scan'208";a="298196438"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/4] async_tx: fix multiple dependency submission
Date: Wed, 13 Feb 2008 08:10:29 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C040101AC@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080213070302.793.11306.stgit@dwillia2-linux.ch.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/4] async_tx: fix multiple dependency submission
Thread-Index: AchuD1MzGppwr5trTp61F2E8eddXKAAS4YEg
References: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com> <20080213070302.793.11306.stgit@dwillia2-linux.ch.intel.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>
Cc: <hskinnemoen@atmel.com>, <olof@lixom.net>, <yur@emcraft.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
X-OriginalArrivalTime: 13 Feb 2008 16:10:30.0469 (UTC) FILETIME=[F44A6F50:01C86E5A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Williams, Dan J 
>Sent: Tuesday, February 12, 2008 11:03 PM
>To: linux-kernel@vger.kernel.org
>Cc: hskinnemoen@atmel.com; Nelson, Shannon; olof@lixom.net; 
>yur@emcraft.com
>Subject: [PATCH 2/4] async_tx: fix multiple dependency submission
>
>Shrink struct dma_async_tx_descriptor and introduce
>async_tx_channel_switch to properly inject a channel switch 
>interrupt in
>the descriptor stream.  This simplifies the locking model as drivers no
>longer need to handle dma_async_tx_descriptor.lock.
>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
>
> crypto/async_tx/async_tx.c |  197 
>++++++++++++++++++++++++++++++++++++--------
> drivers/dma/dmaengine.c    |    2 
> drivers/dma/iop-adma.c     |    9 +-
> include/linux/dmaengine.h  |    9 +-
> 4 files changed, 170 insertions(+), 47 deletions(-)
>
>


Acked-by: Shannon Nelson <shannon.nelson@intel.com>
