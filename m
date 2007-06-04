Return-Path: <linux-kernel-owner+w=401wt.eu-S1760326AbXFDWMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326AbXFDWMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXFDWMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:12:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53819 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104AbXFDWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:12:41 -0400
Date: Tue, 5 Jun 2007 00:12:44 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Peter Oruba <peter.oruba@amd.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>, cramerj@intel.com,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, auke-jan.h.kok@intel.com,
       jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: [-mm patch] e1000: #if 0 two functions
Message-ID: <20070604221244.GC5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

e1000_{read,write}_pci_cfg() are no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/net/e1000/e1000_hw.h   |    2 --
 drivers/net/e1000/e1000_main.c |    4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc3-mm1/drivers/net/e1000/e1000_hw.h.old	2007-06-04 22:03:05.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/net/e1000/e1000_hw.h	2007-06-04 22:03:14.000000000 +0200
@@ -421,8 +421,6 @@ void e1000_tbi_adjust_stats(struct e1000
 void e1000_get_bus_info(struct e1000_hw *hw);
 void e1000_pci_set_mwi(struct e1000_hw *hw);
 void e1000_pci_clear_mwi(struct e1000_hw *hw);
-void e1000_read_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t * value);
-void e1000_write_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t * value);
 int32_t e1000_read_pcie_cap_reg(struct e1000_hw *hw, uint32_t reg, uint16_t *value);
 void e1000_pcix_set_mmrbc(struct e1000_hw *hw, int mmrbc);
 int e1000_pcix_get_mmrbc(struct e1000_hw *hw);
--- linux-2.6.22-rc3-mm1/drivers/net/e1000/e1000_main.c.old	2007-06-04 22:03:24.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/net/e1000/e1000_main.c	2007-06-04 22:03:40.000000000 +0200
@@ -4888,6 +4888,8 @@ e1000_pci_clear_mwi(struct e1000_hw *hw)
 	pci_clear_mwi(adapter->pdev);
 }
 
+#if 0
+
 void
 e1000_read_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t *value)
 {
@@ -4904,6 +4906,8 @@ e1000_write_pci_cfg(struct e1000_hw *hw,
 	pci_write_config_word(adapter->pdev, reg, *value);
 }
 
+#endif  /*  0  */
+
 int
 e1000_pcix_get_mmrbc(struct e1000_hw *hw)
 {

