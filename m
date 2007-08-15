Return-Path: <linux-kernel-owner+w=401wt.eu-S964900AbXHOXgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900AbXHOXgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964798AbXHOXgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:36:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:56911 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964796AbXHOXgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:36:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,268,1183359600"; 
   d="scan'208";a="263739318"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm patch] DMA engine kconfig improvements
Date: Wed, 15 Aug 2007 16:36:33 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02DEBD8C@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070726052628.GL3572@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm patch] DMA engine kconfig improvements
Thread-Index: AcfPRZYo8lb0rpZQT/K1l4QU0snk1AQTpixA
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070726052628.GL3572@stusta.de>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Satyam Sharma" <ssatyam@cse.iitk.ac.in>
X-OriginalArrivalTime: 15 Aug 2007 23:36:33.0571 (UTC) FILETIME=[1D293730:01C7DF95]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Adrian Bunk [mailto:bunk@stusta.de] 
>Sent: Wednesday, July 25, 2007 10:26 PM
>To: Andrew Morton; Nelson, Shannon
>Cc: linux-kernel@vger.kernel.org
>Subject: [-mm patch] DMA engine kconfig improvements
>
>On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>>...
>> Changes since 2.6.22-rc6-mm1:
>>...
>> +dma-arch-fix.patch
>> 
>>  Fix git-dma.patch
>>...
>
>This results in an ARM-only driver in an X86-only menu...
>
>What about the patch below instead that also improves a few 
>other things?
>
>
><--  snip  -->
>
>
>This patch contains the following changes to the DMA engine menus:
>- switch to menuconfig
>- INTEL_IOATDMA must depend on X86
>- INTEL_IOATDMA must select DCA
>- device drivers shouldn't "default m"
>- DCA shouldn't be a user visible option
>- make it clear in the INTEL_IOATDMA help text that this driver is for
>  rare hardware the user most likely doesn't has
>- let DMA_ENGINE be select'ed by the DMA devices, making it less likely
>  for a user to accidentally enable NET_DMA
>
>Signed-off-by: Adrian Bunk <bunk@stusta.de>
>

Thanks, Adrian.  With a couple minor notes changes, I'm using this
patch.  What's nice is this also takes care of the DCA configuration
issue as well such that I don't need to add #ifdef's to the code.  Doing
this changes an argument I gave to Satyam, but the effect is small
enough that it shouldn't matter.

Once I get my git tree cleaned up again (I'll learn this part yet...)
I'll have it out, probably tomorrow.

sln
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
