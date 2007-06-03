Return-Path: <linux-kernel-owner+w=401wt.eu-S1751428AbXFCUXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbXFCUXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXFCUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:23:35 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34307 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbXFCUXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:23:35 -0400
Date: Sun, 3 Jun 2007 23:23:33 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: libata & no PCI: dma_[un]map_single undefined
Message-ID: <Pine.SOC.4.64.0706032314590.20033@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I accidentally enabled libata config options on my Sun Ultra 1 (sparc64, 
UP, no PCI, only SBUS):

  MODPOST 440 modules
ERROR: "dma_unmap_sg" [drivers/ata/libata.ko] undefined!
ERROR: "dma_map_sg" [drivers/ata/libata.ko] undefined!
ERROR: "dma_unmap_single" [drivers/ata/libata.ko] undefined!
ERROR: "dma_mapping_error" [drivers/ata/libata.ko] undefined!
ERROR: "dma_map_single" [drivers/ata/libata.ko] undefined!

CONFIG_PCI=n
CONFIG_ATA=m

This seems to be a valid configuration since libata can drive non-PCI 
devices too?

-- 
Meelis Roos (mroos@linux.ee)
