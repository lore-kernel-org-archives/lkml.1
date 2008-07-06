Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYGFNH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYGFNH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbYGFNBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:59028 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYGFNBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Zac/I4ErwiQSJ0bXMMgplJOYoO+9KtrWP2f4I4vhWR7xV7hBFiStEy9Zu9+BIYge8t
         jChRlGFMjDl4+Nlqxg7qvVckPiXwOjhmEA+GuC3aoJcr1mF1NifyuHimaozb1/EFS24g
         dEkt/0/CjZnzQyyX+AU6v2t95Jrz8xz5vULik=
Message-ID: <a4423d670807060601sa56948ak812c4569297fada6@mail.gmail.com>
Date: Sun, 6 Jul 2008 17:01:34 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi_cmnd.h: remove double inclusion of linux/blkdev.h
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

Remove double inclusion of linux/blkdev.h

 include/scsi/scsi_cmnd.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3e46dfa..66c9448 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
-#include <linux/blkdev.h>

 struct Scsi_Host;
 struct scsi_device;
