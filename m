Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYBLIjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYBLIjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYBLIiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:38:51 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:38234 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751071AbYBLIiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:38:50 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-29.messagelabs.com!1202805529!3971791!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: netdev@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix alignment of IP-Config output
Date: Tue, 12 Feb 2008 09:38:46 +0100
Message-Id: <1202805526-646-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 12 Feb 2008 08:38:46.0778 (UTC) FILETIME=[AED1A5A0:01C86D52]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15724.003
X-TM-AS-Result: No--4.965800-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make the intended lines aligned in the output (not in the code)

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 net/ipv4/ipconfig.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index a52b585..10013cc 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1390,7 +1390,7 @@ static int __init ip_auto_config(void)
 	 * Clue in the operator.
 	 */
 	printk("IP-Config: Complete:");
-	printk("\n      device=%s", ic_dev->name);
+	printk("\n     device=%s", ic_dev->name);
 	printk(", addr=%u.%u.%u.%u", NIPQUAD(ic_myaddr));
 	printk(", mask=%u.%u.%u.%u", NIPQUAD(ic_netmask));
 	printk(", gw=%u.%u.%u.%u", NIPQUAD(ic_gateway));
-- 
1.5.4

