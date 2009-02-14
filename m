Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZBNVQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZBNVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZBNVOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:14:38 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:48160 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZBNVOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:14:36 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 10/43] drivers/net/s2io.c: fix sparse warning: symbol shadows
	an earlier one
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:14:31 +0100
Message-ID: <20090214211423.23489.10245.stgit@vmbox.hanneseder.net>
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
  drivers/net/s2io.c:7223:21: warning: symbol 'i' shadows an earlier one
  drivers/net/s2io.c:7184:13: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/s2io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 5cd2291..16868b7 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -7220,7 +7220,6 @@ static int s2io_card_up(struct s2io_nic * sp)
 
 	/* Initialise napi */
 	if (config->napi) {
-		int i;
 		if (config->intr_type ==  MSI_X) {
 			for (i = 0; i < sp->config.rx_ring_num; i++)
 				napi_enable(&sp->mac_control.rings[i].napi);

