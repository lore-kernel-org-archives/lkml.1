Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXFSIe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXFSIe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbXFSIev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:34:51 -0400
Received: from server78.greatnet.de ([83.133.96.102]:49421 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbXFSIeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:34:50 -0400
X-Greylist: delayed 1753 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 04:34:50 EDT
Message-ID: <46778F8A.2080108@nachtwindheim.de>
Date: Tue, 19 Jun 2007 10:10:50 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kerneldoc fix in libata
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix parameter name from ata_dev_reread_id() in libata-core.c for kerneldoc.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 047eabd..88e2761 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3659,7 +3659,7 @@ static int ata_dev_same_device(struct at
 
 /**
  *	ata_dev_reread_id - Re-read IDENTIFY data
- *	@adev: target ATA device
+ *	@dev: target ATA device
  *	@readid_flags: read ID flags
  *
  *	Re-read IDENTIFY page and make sure @dev is still attached to


