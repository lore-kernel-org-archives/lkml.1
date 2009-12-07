Return-Path: <linux-kernel-owner+w=401wt.eu-S934466AbZLGA2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934466AbZLGA2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932791AbZLGA2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:28:32 -0500
Received: from kroah.org ([198.145.64.141]:34408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758458AbZLGANH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:49 2009
Message-Id: <20091207000648.921171433@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>, wey-yi.w.guy@intel.com,
       linville@tuxdriver.com
Subject: [049/119] iwlwifi: Fix issue on file transfer stalled in HT mode
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=iwlwifi-fix-issue-on-file-transfer-stalled-in-ht-mode.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit d01032e4fd33110f9f3a085a36cb819c1dfc5827 upstream

Turn on RTS/CTS for HT to prevent uCode TX fifo underrun

This is fix for
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2103

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Tested-by: Jiajia Zheng <jiajia.zheng@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -71,5 +71,6 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.need_pll_cfg = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 


