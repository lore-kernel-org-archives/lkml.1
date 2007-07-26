Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbXGZIbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbXGZIbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXGZIbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:31:25 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:52201 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbXGZIbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:31:25 -0400
Date: Thu, 26 Jul 2007 11:31:24 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: libsas: pci_iommu_ops undefined on !PCI
Message-ID: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tried to compile everythin SCSI on my SBus-only sparc64, including SAS 
supoort. Seems that libsas seems to depend on PCI - does it need to?

  MODPOST 446 modules
ERROR: "pci_iommu_ops" [drivers/scsi/libsas/libsas.ko] undefined!

-- 
Meelis Roos (mroos@linux.ee)
