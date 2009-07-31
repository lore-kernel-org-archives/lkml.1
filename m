Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZGaHXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZGaHXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZGaHXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:23:37 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:3032 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZGaHXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:23:36 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 1/2 net-next-2.6] cxgb3: fix EDC filename string
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Fri, 31 Jul 2009 00:23:34 -0700
Message-ID: <20090731072334.4325.34323.stgit@speedy5>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Fix a cut'n paste error in the AEL2020 twinax EDC file name

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index ec05149..8b3e76c 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -993,7 +993,7 @@ static int bind_qsets(struct adapter *adap)
 #define TPSRAM_NAME "cxgb3/t3%c_psram-%d.%d.%d.bin"
 #define AEL2005_OPT_EDC_NAME "cxgb3/ael2005_opt_edc.bin"
 #define AEL2005_TWX_EDC_NAME "cxgb3/ael2005_twx_edc.bin"
-#define AEL2020_TWX_EDC_NAME "cxgb3/ael2005_twx_edc.bin"
+#define AEL2020_TWX_EDC_NAME "cxgb3/ael2020_twx_edc.bin"
 
 static inline const char *get_edc_fw_name(int edc_idx)
 {

