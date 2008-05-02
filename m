Return-Path: <linux-kernel-owner+w=401wt.eu-S965779AbYEBTIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965779AbYEBTIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964997AbYEBTFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:43 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:53287 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964927AbYEBTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XINvEi79eXQAvFSp5Ojci8iCUmuDXUfUXXdVQ6GmRra61YnQ8rj+dH6uuL9xsdYf3m4SesJ290En1PUwHce/GiF8RHmnw/YJnvIHStoiWHVp+QdRzqwj/UDoR/GmuR+hMVC/x6AQagy5AY5w5EeXb2l4q9nHuP4lZP/RMAPzM3E=
Subject: [PATCH 04/14] scsi: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:55 -0700
Message-Id: <1209755155.26173.70.camel@brick>
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


