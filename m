Return-Path: <linux-kernel-owner+w=401wt.eu-S1763078AbYCAQ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078AbYCAQ1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763195AbYCAQY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:24:28 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39209 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763181AbYCAQY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:24:27 -0500
Date: Sat, 1 Mar 2008 18:23:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Auke Kok <auke-jan.h.kok@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jeff Garzik <jeff@garzik.org>, jesse.brandeburg@intel.com,
       john.ronciak@intel.com
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [RFC: 2.6 patch] #if 0 e1000e_read_nvm_spi()
Message-ID: <20080301162302.GX25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the no longer used e1000e_read_nvm_spi().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/e1000e/e1000.h |    1 -
 drivers/net/e1000e/lib.c   |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

9bab4dc421a7e5a947739e2fa1363b4efffbcbe2 foobar
diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index 327c062..6e0c6ed 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -462,7 +462,6 @@ extern s32 e1000e_acquire_nvm(struct e1000_hw *hw);
 extern s32 e1000e_write_nvm_spi(struct e1000_hw *hw, u16 offset, u16 words, u16 *data);
 extern s32 e1000e_update_nvm_checksum_generic(struct e1000_hw *hw);
 extern s32 e1000e_poll_eerd_eewr_done(struct e1000_hw *hw, int ee_reg);
-extern s32 e1000e_read_nvm_spi(struct e1000_hw *hw, u16 offset, u16 words, u16 *data);
 extern s32 e1000e_read_nvm_eerd(struct e1000_hw *hw, u16 offset, u16 words, u16 *data);
 extern s32 e1000e_validate_nvm_checksum_generic(struct e1000_hw *hw);
 extern void e1000e_release_nvm(struct e1000_hw *hw);
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index 95f75a4..cb2dac8 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -1851,6 +1851,7 @@ static s32 e1000_ready_nvm_eeprom(struct e1000_hw *hw)
 	return 0;
 }
 
+#if 0
 /**
  *  e1000e_read_nvm_spi - Reads EEPROM using SPI
  *  @hw: pointer to the HW structure
@@ -1906,6 +1907,7 @@ s32 e1000e_read_nvm_spi(struct e1000_hw *hw, u16 offset, u16 words, u16 *data)
 	nvm->ops.release_nvm(hw);
 	return 0;
 }
+#endif  /*  0  */
 
 /**
  *  e1000e_read_nvm_eerd - Reads EEPROM using EERD register

