Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZBTRg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZBTRg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbZBTReu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:34:50 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:50384 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbZBTRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=c6azlyufI3D8LFWsv0HZZmMHccmuVY9jUByeHieqAM9G4lEtBLIiYV5sMqqxdpVmup
         gGtg8usn6HfpYrwbuCXPa6yGmRE7uDZS7DC1aOdXOvrm+TiTRkXyyiYoSw8gsIkkk4mU
         cbPVTrckWo2oYwXzrLFEgtUZ77w3F4ABU9MQg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] remove stale comment from <linux/hdreg.h>
Date: Fri, 20 Feb 2009 18:36:02 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090219; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902201836.02841.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] remove stale comment from <linux/hdreg.h>

HDIO_GET_IDENTITY returns 256 words currently.

Noticed by Norman Diamond.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/hdreg.h |    1 -
 1 file changed, 1 deletion(-)

Index: b/include/linux/hdreg.h
===================================================================
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -511,7 +511,6 @@ struct hd_driveid {
 	unsigned short	words69_70[2];	/* reserved words 69-70
 					 * future command overlap and queuing
 					 */
-	/* HDIO_GET_IDENTITY currently returns only words 0 through 70 */
 	unsigned short	words71_74[4];	/* reserved words 71-74
 					 * for IDENTIFY PACKET DEVICE command
 					 */
