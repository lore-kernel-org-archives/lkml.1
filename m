Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab0BBPbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:31:20 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:47080 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab0BBPbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:31:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=O0JThB5KQe86jEIAcmcK3/DWNp+23oIohTp9NbyvLM+Srbxdt5IcpiFQRCYuOGib82
         HvR9saB8r4NEfj0j4hmNXKG2S4rUL3hW/RN3BAQ1a60K6pYDC2B1UbedcBD/A1FdZEIp
         hsERw/dA/vREfQ3NdPG1j0/VrpPlV0ynpbPlM=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: [patch 1/7] roll back reiser4-fixed-null-pointer-dereference.patch
Date: Tue, 2 Feb 2010 16:24:45 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
MIME-Version: 1.0
Message-Id: <201002021624.45767.edward.shishkin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roll back reiser4-fixed-null-pointer-dereference.patch
(wrong stuff)

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 fs/reiser4/super_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
Index: linux-2.6.33-rc5-mm1/fs/reiser4/super_ops.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/super_ops.c
+++ linux-2.6.33-rc5-mm1/fs/reiser4/super_ops.c
@@ -395,7 +395,7 @@ static void reiser4_sync_inodes(struct s
 	reiser4_context *ctx;
 	long to_write;
 
-	if (wbc == NULL || wbc->for_kupdate)
+	if (wbc->for_kupdate)
 		/* reiser4 has its own means of periodical write-out */
 		return;
 
