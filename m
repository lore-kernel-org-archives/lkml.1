Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYADUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYADUmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYADUlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:41:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:1198 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYADUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=o0jTWzptGVLGfC2jwXfbUHMjYGYGIRaAxEdksy+cHNe8zyp/rCMUnWgBY1eCnIDdw5rxfu8u1Ur6YhdR4K2+p9OzmoA3skf8TcR7r7lUAQwh5tjBg+vEQ+yNizzXT2c5pBg3AWKrjn1fdwOorx/7zAuCbH43TzcDVtOOGHtcx3Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide: don't include <linux/hdsmart.h>
Date: Fri, 4 Jan 2008 21:52:11 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801042152.11312.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


IDE doesn't need it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    1 -
 1 file changed, 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -9,7 +9,6 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/hdreg.h>
-#include <linux/hdsmart.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
