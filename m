Return-Path: <linux-kernel-owner+w=401wt.eu-S1764920AbXJPAah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764920AbXJPAah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXJPAaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:30:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44810 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbXJPAaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:30:23 -0400
Date: Mon, 15 Oct 2007 17:29:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, jgarzik <jgarzik@pobox.com>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>,
       ide <linux-ide@vger.kernel.org>
Subject: [PATCH 2/4] docbook: fix libata content
Message-Id: <20071015172946.ff34b548.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix libata docbook warnings.

Warning(linux-2.6.23-git8//drivers/ata/libata-scsi.c:3251): No description found for parameter 'dev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-git8.orig/drivers/ata/libata-scsi.c
+++ linux-2.6.23-git8/drivers/ata/libata-scsi.c
@@ -3239,7 +3239,7 @@ static void ata_scsi_handle_link_detach(
 
 /**
  *	ata_scsi_media_change_notify - send media change event
- *	@atadev: Pointer to the disk device with media change event
+ *	@dev: Pointer to the disk device with media change event
  *
  *	Tell the block layer to send a media change notification
  *	event.
