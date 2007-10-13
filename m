Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbXJMSmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbXJMSmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761390AbXJMSmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:42:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42907 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762224AbXJMSmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:42:46 -0400
Date: Sat, 13 Oct 2007 19:42:42 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fallout from elsa setup split
Message-ID: <20071013184242.GM8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

... and yes, caller wants it to return int.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index 0c1351b..948a9b2 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -1088,7 +1088,7 @@ setup_elsa_pci(struct IsdnCard *card)
 
 #else
 
-static void __devinit
+static int __devinit
 setup_elsa_pci(struct IsdnCard *card)
 {
 	return (1);
