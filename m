Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZKHU2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZKHU2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZKHU0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:26:01 -0500
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755330AbZKHUZ5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:25:57 -0500
Subject: [PATCH 18/20] scsi/scsi.h: No longer use Scsi_Cmd typedef
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       drew@colorado.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 08 Nov 2009 17:17:30 -0300
Message-ID: <1257711450.4759.124.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove scsi_typedefs.h reference.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/scsi.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
index d5a55fa..db67d4c 100644
--- a/drivers/scsi/scsi.h
+++ b/drivers/scsi/scsi.h
@@ -42,7 +42,4 @@ struct scsi_device;
 struct scsi_target;
 struct scatterlist;
 
-/* obsolete typedef junk. */
-#include "scsi_typedefs.h"
-
 #endif /* _SCSI_H */




