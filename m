Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYDXB0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYDXB0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYDXB0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:26:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:48584 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbYDXB0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:26:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,701,1199692800"; 
   d="scan'208";a="556380569"
Date: Thu, 24 Apr 2008 09:19:44 +0800
From: Alek Du <alek.du@intel.com>
To: "Barnes, Jesse" <jesse.barnes@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@suse.de>
Subject: Re: [PATCH 1/3] pci: Add Intel SCH PCI IDs
Message-ID: <20080424091944.25f20bd7@dxy.sh.intel.com>
In-Reply-To: <200804231551.05220.jesse.barnes@intel.com>
References: <20080422100140.71f947ca@dxy.sh.intel.com>
	<200804231551.05220.jesse.barnes@intel.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2008 01:26:28.0032 (UTC) FILETIME=[37DD1C00:01C8A5AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,

Thanks. Trimmed it to add only two IDs, here is the patch:

This patch adds Intel SCH chipsets (US15W, US15L, UL11L) PCI IDs, these
IDs will be used by following SCH driver patches.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 include/linux/pci_ids.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 70eb3c8..b72b3b4 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2413,6 +2413,8 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
+#define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
 #define PCI_DEVICE_ID_INTEL_82450GX	0x84c5
 #define PCI_DEVICE_ID_INTEL_82451NX	0x84ca
-- 
1.5.2.5

Thanks,
Alek

On Thu, 24 Apr 2008 06:51:04 +0800
"Barnes, Jesse" <jesse.barnes@intel.com> wrote:

> Re: [PATCH 1/3] pci: Add Intel SCH PCI IDs
> 
> On Monday, April 21, 2008 7:01 pm alek du wrote:
> > This patch adds Intel SCH chipsets (US15W, US15L, UL11L) PCI IDs,
> > these IDs will be used by following SCH driver patches.
> >
> > Signed-off-by: Alek Du <alek.du@intel.com>
> > ---
> >  include/linux/pci_ids.h |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> Alex, can any of these IDs be trimmed?  We only want to bloat
> pci_ids.h with the stuff that's actually used in several drivers.
> Other IDs can just be defined directly in the driver in question...
> 
> Thanks,
> Jesse
