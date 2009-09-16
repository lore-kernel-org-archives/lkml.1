Return-Path: <linux-kernel-owner+w=401wt.eu-S1760469AbZIPWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469AbZIPWlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760443AbZIPWlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:41:05 -0400
Received: from kroah.org ([198.145.64.141]:55453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626AbZIPWk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:19 2009
Message-Id: <20090916223719.697894760@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 43/45] PCI quirk: update 82576 device ids in SR-IOV quirks list
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=pci-quirk-update-82576-device-ids-in-sr-iov-quirks-list.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>

commit 6f1186be4feb3364d3a52cbea81e43e4d5296196 upstream.

This patch adds the most recent additions to the list of 82576 device IDs
to the list of devices needing the SR-IOV quirk.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2494,6 +2494,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10e7, quirk_i82576_sriov);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x10e8, quirk_i82576_sriov);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x150a, quirk_i82576_sriov);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x150d, quirk_i82576_sriov);
 
 #endif	/* CONFIG_PCI_IOV */
 


