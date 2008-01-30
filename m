Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYA3Og7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYA3Og7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYA3Ogs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:36:48 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:36738 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYA3Ogr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:36:47 -0500
Message-ID: <47A08B7C.9010205@tiscali.nl>
Date: Wed, 30 Jan 2008 15:36:44 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][net/sched/sch_teql.c] duplicate IFF_BROADCAST in FMASK, remove
 2nd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested patch below, please confirm it's the right fix (should it be some
other IFF_*?)
--
duplicate IFF_BROADCAST, remove 2nd

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index c0ed06d..a53acf4 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -71,7 +71,7 @@ struct teql_sched_data
 
 #define NEXT_SLAVE(q) (((struct teql_sched_data*)qdisc_priv(q))->next)
 
-#define FMASK (IFF_BROADCAST|IFF_POINTOPOINT|IFF_BROADCAST)
+#define FMASK (IFF_BROADCAST|IFF_POINTOPOINT)
 
 /* "teql*" qdisc routines */
 
