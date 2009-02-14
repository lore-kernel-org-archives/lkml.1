Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZBNVNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZBNVNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZBNVMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:12:41 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:39192 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZBNVMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:12:40 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 04/43] drivers/net/ns83820.c: fix sparse warnings: fix
	signedness
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:12:36 +0100
Message-ID: <20090214211231.23489.52423.stgit@vmbox.hanneseder.net>
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
  drivers/net/ns83820.c:479:36: warning: incorrect type in argument 2 (different signedness)
  drivers/net/ns83820.c:479:36: warning: incorrect type in argument 2 (different signedness)
  drivers/net/ns83820.c:479:36: warning: incorrect type in argument 2 (different signedness)
  drivers/net/ns83820.c:479:36: warning: incorrect type in argument 2 (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/ns83820.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ns83820.c b/drivers/net/ns83820.c
index e80294d..9266502 100644
--- a/drivers/net/ns83820.c
+++ b/drivers/net/ns83820.c
@@ -409,7 +409,7 @@ static int lnksts = 0;		/* CFG_LNKSTS bit polarity */
 struct rx_info {
 	spinlock_t	lock;
 	int		up;
-	long		idle;
+	unsigned long	idle;
 
 	struct sk_buff	*skbs[NR_RX_DESC];
 

