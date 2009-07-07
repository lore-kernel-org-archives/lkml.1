Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbZGGOfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbZGGOfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbZGGOei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:34:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:42697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758309AbZGGOeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:34:37 -0400
Subject: [PATCH 9/22] trivial: fix typo "could could" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:45:22 +0530
Message-Id: <1246976122.3613.25.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced "could could" with "could" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 net/rds/ib_cm.c |    2 +-
 net/rds/iw_cm.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index f8e40e1..42268a9 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -354,7 +354,7 @@ static u32 rds_ib_protocol_compatible(const struct rds_ib_connect_private *dp)
 	 * original size. The only way to tell the difference is by looking at
 	 * the contents, which are initialized to zero.
 	 * If the protocol version fields aren't set, this is a connection attempt
-	 * from an older version. This could could be 3.0 or 2.0 - we can't tell.
+	 * from an older version. This could be 3.0 or 2.0 - we can't tell.
 	 * We really should have changed this for OFED 1.3 :-( */
 	if (dp->dp_protocol_major == 0)
 		return RDS_PROTOCOL_3_0;
diff --git a/net/rds/iw_cm.c b/net/rds/iw_cm.c
index a416b0d..784558e 100644
--- a/net/rds/iw_cm.c
+++ b/net/rds/iw_cm.c
@@ -352,7 +352,7 @@ static u32 rds_iw_protocol_compatible(const struct rds_iw_connect_private *dp)
 	 * original size. The only way to tell the difference is by looking at
 	 * the contents, which are initialized to zero.
 	 * If the protocol version fields aren't set, this is a connection attempt
-	 * from an older version. This could could be 3.0 or 2.0 - we can't tell.
+	 * from an older version. This could be 3.0 or 2.0 - we can't tell.
 	 * We really should have changed this for OFED 1.3 :-( */
 	if (dp->dp_protocol_major == 0)
 		return RDS_PROTOCOL_3_0;
-- 
1.6.0.6



