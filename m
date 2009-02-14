Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZBNWoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZBNWoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZBNWo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:44:28 -0500
Received: from mail-fx0-f25.google.com ([209.85.220.25]:36203 "EHLO
	mail-fx0-f25.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZBNWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:44:27 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH] drivers/isdn/hardware/mISDN: change type of hfc_jiffies to
	ulong
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Date: Sat, 14 Feb 2009 23:44:21 +0100
Message-ID: <20090214224049.28194.38982.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch suggested by Jiri Slaby.

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---

This patch is based on:
    drivers/isdn/hardware/mISDN: fix sparse warnings: make symbols static

 drivers/isdn/hardware/mISDN/hfcpci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 2bb85c4..c7a855c 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -57,7 +57,7 @@ static int HFC_cnt;
 static uint debug;
 static uint poll, tics;
 static struct timer_list hfc_tl;
-static u32 hfc_jiffies;
+static ulong hfc_jiffies;
 
 MODULE_AUTHOR("Karsten Keil");
 MODULE_LICENSE("GPL");

