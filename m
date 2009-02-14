Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZBNVuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZBNVuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZBNVte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:49:34 -0500
Received: from mail-bw0-f167.google.com ([209.85.218.167]:33840 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbZBNVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:49:33 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 39/43] drivers/net/wireless: fix sparse warnings: fix
	signedness
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:49:26 +0100
Message-ID: <20090214214917.24377.97223.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  drivers/net/wireless/airo.c:2102:21: warning: incorrect type in initializer (different signedness)
  drivers/net/wireless/airo.c:2126:21: warning: incorrect type in initializer (different signedness)
  drivers/net/wireless/airo.c:2167:21: warning: incorrect type in initializer (different signedness)
  drivers/net/wireless/airo.c:2191:21: warning: incorrect type in initializer (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/wireless/airo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 220f00b..e64eab4 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1161,7 +1161,7 @@ struct airo_info {
 	   use the high bit to mark whether it is in use. */
 #define MAX_FIDS 6
 #define MPI_MAX_FIDS 1
-	int                           fids[MAX_FIDS];
+	u32                           fids[MAX_FIDS];
 	ConfigRid config;
 	char keyindex; // Used with auto wep
 	char defindex; // Used with auto wep

