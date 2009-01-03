Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbZACH6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbZACH6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACH6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:58:11 -0500
Received: from vps1.tull.net ([66.180.172.116]:37933 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759AbZACH6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:58:10 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 08/11] Fix misspelling of "firmware" in qla1280.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:57:37 +1100
Message-ID: <20090103075727.27466.41093.stgit@marcab.local>
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

Fix misspelling of "firmware" in qla1280.c

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/scsi/qla1280.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index b6cd12b..cc57a23 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -128,7 +128,7 @@
 	- Integrate ql12160_set_target_parameters() with 1280 version
 	- Make qla1280_setup() non static
 	- Do not call qla1280_check_for_dead_scsi_bus() on every I/O request
-	  sent to the card - this command pauses the firmare!!!
+	  sent to the card - this command pauses the firmware!!!
     Rev  3.23.15 Beta March 19, 2002, Jes Sorensen
 	- Clean up qla1280.h - remove obsolete QL_DEBUG_LEVEL_x definitions
 	- Remove a pile of pointless and confusing (srb_t **) and
@@ -659,7 +659,7 @@ static int qla1280_read_nvram(struct scsi_qla_host *ha)
 	/* The firmware interface is, um, interesting, in that the
 	 * actual firmware image on the chip is little endian, thus,
 	 * the process of taking that image to the CPU would end up
-	 * little endian.  However, the firmare interface requires it
+	 * little endian.  However, the firmware interface requires it
 	 * to be read a word (two bytes) at a time.
 	 *
 	 * The net result of this would be that the word (and

