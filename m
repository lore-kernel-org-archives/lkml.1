Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYFPFKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYFPFKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 01:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYFPFKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 01:10:03 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:53581 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYFPFKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 01:10:01 -0400
Message-ID: <4855F5A4.4020109@freemail.hu>
Date: Mon, 16 Jun 2008 07:09:56 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] 8139too: add missing brackets
References: <4853BB7B.4030905@freemail.hu> <48541173.7040905@freemail.hu> <4854B604.6080900@davidnewall.com>
In-Reply-To: <4854B604.6080900@davidnewall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC--Metrics: mail01d.mail.t-online.hu 0; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Clean up the following error reported by checkpatch.pl:
 - Macros with complex values should be enclosed in parenthesis

The macro RTL8139_CAPS currently only used as a whole expression
to initialize board_info[] so this change won't change the resulting code.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- a/drivers/net/8139too.c	2008-06-14 00:20:47.000000000 +0200
+++ b/drivers/net/8139too.c	2008-06-16 07:03:20.000000000 +0200
@@ -219,7 +219,7 @@ enum {
 #define RTL8139B_IO_SIZE 256

 #define RTL8129_CAPS	HAS_MII_XCVR
-#define RTL8139_CAPS	HAS_CHIP_XCVR|HAS_LNK_CHNG
+#define RTL8139_CAPS	(HAS_CHIP_XCVR|HAS_LNK_CHNG)

 typedef enum {
 	RTL8139 = 0,
