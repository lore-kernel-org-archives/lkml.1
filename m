Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbZACH5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbZACH5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACH5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:57:11 -0500
Received: from vps1.tull.net ([66.180.172.116]:37930 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759AbZACH5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:57:10 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 07/11] Fix misspelling of "firmware" in a100u2w.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:56:38 +1100
Message-ID: <20090103075628.27466.93447.stgit@marcab.local>
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of "firmware" in a100u2w.c

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/scsi/a100u2w.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 84bb616..07df412 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -633,7 +633,7 @@ static int orc_device_reset(struct orc_host * host, struct scsi_cmnd *cmd, unsig
 		return FAILED;
 	}
 
-	/* Reset device is handled by the firmare, we fill in an SCB and
+	/* Reset device is handled by the firmware, we fill in an SCB and
 	   fire it at the controller, it does the rest */
 	scb->opcode = ORC_BUSDEVRST;
 	scb->target = target;

