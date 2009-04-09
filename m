Return-Path: <linux-kernel-owner+w=401wt.eu-S937170AbZDIW7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937170AbZDIW7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZDIW7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:59:25 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:38604 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111AbZDIW7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:59:25 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH]Silencing warning: 'host' may be used uninitialized in this function
Date: Fri, 10 Apr 2009 01:33:58 +0300
User-Agent: KMail/1.9.10
Cc: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904100133.58556.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I do not know if that is worth the effort, but...

Silencing:  warning: 'host' may be used uninitialized in this function
It is a false positive.

The patch is against 2.6.30-rc1, but should apply to 2.6.29(.1) too.

Signed-off-by: Marin Mitov mitov@issp.bas.bg
================================================
--- a/drivers/ata/sata_via.c	2009-04-05 22:59:26.000000000 +0300
+++ b/drivers/ata/sata_via.c	2009-04-06 00:07:25.000000000 +0300
@@ -566,7 +566,7 @@
 	static int printed_version;
 	unsigned int i;
 	int rc;
-	struct ata_host *host;
+	struct ata_host *host = host;
 	int board_id = (int) ent->driver_data;
 	const unsigned *bar_sizes;
 
