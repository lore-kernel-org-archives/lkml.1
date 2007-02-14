Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbXBNAT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbXBNAT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbXBNAT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:19:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:62043 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbXBNAT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:19:26 -0500
Date: Tue, 13 Feb 2007 16:15:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: axboe@kernel.dk, akpm <akpm@osdl.org>
Subject: [PATCH] cdrom: use unsigned bitfields
Message-Id: <20070213161521.ba566a90.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix 23 of these sparse warnings on x86_64 allmodconfig:
include/linux/cdrom.h:942:19: error: dubious bitfield without explicit `signed' or `unsigned'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/cdrom.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20-git9.orig/include/linux/cdrom.h
+++ linux-2.6.20-git9/include/linux/cdrom.h
@@ -939,7 +939,7 @@ struct cdrom_device_info {
 	int speed;			/* maximum speed for reading data */
 	int capacity;			/* number of discs in jukebox */
 /* device-related storage */
-	int options		: 30;	/* options flags */
+	unsigned int options	: 30;	/* options flags */
 	unsigned mc_flags	: 2;	/* media change buffer flags */
     	int use_count;                  /* number of times device opened */
     	char name[20];                  /* name of the device type */
