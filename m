Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYEBDxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYEBDxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbYEBDww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:52:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48822 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbYEBDwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YXLEg/wiZtvCJFqySPsWIxMEBlcyXl2EtjYAX4jDaUzeR7vzpPjQwxJ8TI3LsdrBirAVpAt/3O9GyFiCc4Ew6MT5hGYgF0/hrHcxpDcRs05JlxZvJmaG84GFQ/UTA0qadXEu9R8coUMW9xe9XGzLkabNqXXpUNaMOKVtVyriN0Y=
Subject: [PATCH 4/8] scsi: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:52:56 -0700
Message-Id: <1209700376.22362.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 010c1b9..7646e86 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -508,7 +508,7 @@ invalid_datalen:
 			goto out;
 		}
 
-		senselen = be16_to_cpu(get_unaligned((__be16 *) data));
+		senselen = get_unaligned_be16(data);
 		if (datalen < senselen)
 			goto invalid_datalen;
 
-- 
1.5.5.1.350.gbbbf


