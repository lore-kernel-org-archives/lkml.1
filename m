Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYC3XWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYC3XWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYC3XW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:22:28 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58952 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbYC3XW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:22:27 -0400
Date: Mon, 31 Mar 2008 02:22:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dhananjay Phadke <dhananjay@netxen.com>, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 netxen_nic_link_ok()
Message-ID: <20080330232214.GO28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the no longer used netxen_nic_link_ok().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/netxen/netxen_nic.h     |    1 -
 drivers/net/netxen/netxen_nic_isr.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

93342d145e487d32d7def8990c3395cfefab4e06 diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index 7f20a03..ca339cf 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -1050,7 +1050,6 @@ void netxen_halt_pegs(struct netxen_adapter *adapter);
 int netxen_rom_se(struct netxen_adapter *adapter, int addr);
 
 /* Functions from netxen_nic_isr.c */
-int netxen_nic_link_ok(struct netxen_adapter *adapter);
 void netxen_initialize_adapter_sw(struct netxen_adapter *adapter);
 void netxen_initialize_adapter_hw(struct netxen_adapter *adapter);
 void *netxen_alloc(struct pci_dev *pdev, size_t sz, dma_addr_t * ptr,
diff --git a/drivers/net/netxen/netxen_nic_isr.c b/drivers/net/netxen/netxen_nic_isr.c
index c81313b..f487615 100644
--- a/drivers/net/netxen/netxen_nic_isr.c
+++ b/drivers/net/netxen/netxen_nic_isr.c
@@ -172,6 +172,7 @@ void netxen_nic_gbe_handle_phy_intr(struct netxen_adapter *adapter)
 	netxen_nic_isr_other(adapter);
 }
 
+#if 0
 int netxen_nic_link_ok(struct netxen_adapter *adapter)
 {
 	switch (adapter->ahw.board_type) {
@@ -189,6 +190,7 @@ int netxen_nic_link_ok(struct netxen_adapter *adapter)
 
 	return 0;
 }
+#endif  /*  0  */
 
 void netxen_nic_xgbe_handle_phy_intr(struct netxen_adapter *adapter)
 {

