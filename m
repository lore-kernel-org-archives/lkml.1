Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbYESVzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbYESVzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYESVzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:55:07 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39752 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYESVzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:55:06 -0400
Date: Tue, 20 May 2008 00:53:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Brice Goglin <brice@myri.com>, Andrew Gallatin <gallatin@myri.com>,
       jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make myri10ge_get_firmware_capabilities() static
Message-ID: <20080519215300.GC17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global 
myri10ge_get_firmware_capabilities() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0442d0c2cb767d312f5264cc226a1595c47f3dbf diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index c91b12e..36be6ef 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -631,7 +631,7 @@ static int myri10ge_adopt_running_firmware(struct myri10ge_priv *mgp)
 	return status;
 }
 
-int myri10ge_get_firmware_capabilities(struct myri10ge_priv *mgp)
+static int myri10ge_get_firmware_capabilities(struct myri10ge_priv *mgp)
 {
 	struct myri10ge_cmd cmd;
 	int status;

