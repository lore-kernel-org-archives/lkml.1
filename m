Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZBQRiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZBQRiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZBQRiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:38:16 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:17716 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZBQRiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:38:16 -0500
Date: Tue, 17 Feb 2009 09:38:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH] staging/android: fix more printk formats
Message-Id: <20090217093841.e6340c41.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.499AF5FD.0097:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix more android ram_console printk format warnings:

drivers/staging/android/ram_console.c:238: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
drivers/staging/android/ram_console.c:238: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/android/ram_console.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20090216.orig/drivers/staging/android/ram_console.c
+++ linux-next-20090216/drivers/staging/android/ram_console.c
@@ -235,8 +235,8 @@ static int __init ram_console_init(struc
 						ECC_BLOCK_SIZE) + 1) * ECC_SIZE;
 
 	if (ram_console_buffer_size > buffer_size) {
-		pr_err("ram_console: buffer %p, invalid size %d, "
-		       "non-ecc datasize %d\n",
+		pr_err("ram_console: buffer %p, invalid size %zu, "
+		       "non-ecc datasize %zu\n",
 		       buffer, buffer_size, ram_console_buffer_size);
 		return 0;
 	}
