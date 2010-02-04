Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab0BDRcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:32:03 -0500
Received: from kroah.org ([198.145.64.141]:34742 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933259Ab0BDRV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:57 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:08 2010
Message-Id: <20100204171508.191802344@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [35/74] iwlwifi: set default aggregation frame count limit to 31
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 4d80d7210bb5a36a18978d1305b44375ecb857d9 upstream.

Multiple MPDUs can be aggregated, transmitted, and finally acknowledged
together using a single BA frame. Block ACK (BA) contains
bitmap size of 64*16 bits so the maximum frame count is 64.
The default value of aggregation frame count suggested by uCode is 31 to
achieve best performance.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2808,7 +2808,7 @@ static void rs_fill_link_cmd(struct iwl_
 		repeat_rate--;
 	}
 
-	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_MAX;
+	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
 	lq_cmd->agg_params.agg_time_limit =
 		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);


