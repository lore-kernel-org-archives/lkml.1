Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZKJDvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZKJDvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZKJDvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:51:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1292 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZKJDvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:51:19 -0500
Subject: [PATCH] parport_pc.c: Use correct length in strncmp
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 19:51:23 -0800
Message-ID: <1257825083.12852.83.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 2597145..ad113b0 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -3403,7 +3403,7 @@ static int __init parport_parse_param(const char *s, int *val,
 		*val = automatic;
 	else if (!strncmp(s, "none", 4))
 		*val = none;
-	else if (nofifo && !strncmp(s, "nofifo", 4))
+	else if (nofifo && !strncmp(s, "nofifo", 6))
 		*val = nofifo;
 	else {
 		char *ep;


