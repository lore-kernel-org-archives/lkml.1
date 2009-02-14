Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZBNVRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZBNVRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZBNVOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:14:51 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:33439 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbZBNVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:14:50 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 11/43] drivers/net/arcnet: fix sparse warning: symbol shadows
	an earlier one
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:14:45 +0100
Message-ID: <20090214211439.23489.20716.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Remove redundant inner scope variable.

Fix this sparse warning:
  drivers/net/arcnet/arcnet.c:383:21: warning: symbol 'count' shadows an earlier one
  drivers/net/arcnet/arcnet.c:375:13: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/arcnet/arcnet.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index a80d4a3..d6d4ab3 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -380,7 +380,6 @@ int arcnet_open(struct net_device *dev)
 		return -ENODEV;
 
 	BUGLVL(D_PROTO) {
-		int count;
 		BUGMSG(D_PROTO, "protocol map (default is '%c'): ",
 		       arc_proto_default->suffix);
 		for (count = 0; count < 256; count++)

