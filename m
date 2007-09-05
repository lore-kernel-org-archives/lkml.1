Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXIEXA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXIEXA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 19:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbXIEW6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 18:58:44 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:18974 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbXIEW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 18:58:42 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 6/7] cxgb3 - Add T3C rev
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Wed, 05 Sep 2007 15:58:36 -0700
Message-ID: <20070905225835.17308.87147.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

add driver recognition for T3C rev board. 

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/common.h     |    1 +
 drivers/net/cxgb3/cxgb3_main.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/cxgb3/common.h b/drivers/net/cxgb3/common.h
index 7e9e43d..d3f276c 100644
--- a/drivers/net/cxgb3/common.h
+++ b/drivers/net/cxgb3/common.h
@@ -438,6 +438,7 @@ enum {					    /* chip revisions */
 	T3_REV_A  = 0,
 	T3_REV_B  = 2,
 	T3_REV_B2 = 3,
+	T3_REV_C  = 4,
 };
 
 struct trace_params {
diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index ae9c213..9d360eb 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -768,6 +768,9 @@ static inline char t3rev2char(struct adapter *adapter)
 	case T3_REV_B2:
 		rev = 'b';
 		break;
+	case T3_REV_C:
+		rev = 'c';
+		break;
 	}
 	return rev;
 }
