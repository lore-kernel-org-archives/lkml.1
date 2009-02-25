Return-Path: <linux-kernel-owner+w=401wt.eu-S1763385AbZBYXKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763385AbZBYXKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbZBYXKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:10:00 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:57249 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZBYXJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:09:59 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 2/5] drivers/isdn/act2000: fix sparse warning: symbol shadows
	an earlier one
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Feb 2009 00:09:52 +0100
Message-ID: <20090225230848.5377.12920.stgit@localhost.localdomain>
In-Reply-To: <20090225230737.5377.31370.stgit@localhost.localdomain>
References: <20090225230737.5377.31370.stgit@localhost.localdomain>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Rename local variable 'c' to 't'.

Fix this sparse warning:
  drivers/isdn/act2000/act2000_isa.c:260:70: warning: symbol 'c' shadows an earlier one

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---

The lines are overlong, but the whole function would need a good
reformating / refactoring in order to obey the 80 character limit.

 drivers/isdn/act2000/act2000_isa.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/act2000/act2000_isa.c b/drivers/isdn/act2000/act2000_isa.c
index 1bd8960..fea5b78 100644
--- a/drivers/isdn/act2000/act2000_isa.c
+++ b/drivers/isdn/act2000/act2000_isa.c
@@ -257,9 +257,9 @@ act2000_isa_receive(act2000_card *card)
 					printk(KERN_WARNING
 					       "act2000_isa_receive: Invalid CAPI msg\n");
 					{
-						int i; __u8 *p; __u8 *c; __u8 tmp[30];
-						for (i = 0, p = (__u8 *)&card->idat.isa.rcvhdr, c = tmp; i < 8; i++)
-							c += sprintf(c, "%02x ", *(p++));
+						int i; __u8 *p; __u8 *t; __u8 tmp[30];
+						for (i = 0, p = (__u8 *)&card->idat.isa.rcvhdr, t = tmp; i < 8; i++)
+							t += sprintf(t, "%02x ", *(p++));
 						printk(KERN_WARNING "act2000_isa_receive: %s\n", tmp);
 					}
 				}

