Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0BNUNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:13:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:63558 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0BNUNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:13:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=XwzXLVhdldcMKJTASUzLdfvOrddTauYiVXzlVzAXichOhGjKUtQON/MTRRBI/RhHMW
         eR7+mQE74miZnJ8daKpG2mBsY9fDgg1qYOyAHsptYN1mKeQcLjFKqqRBmwrhFeeqGKmx
         8+kIH7QoX3VXvo6iiDLtyzsNCKAHWxoEW6ruw=
From: Alessandro Ghedini <al3xbio@gmail.com>
To: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com,
       karllinuxtest.relton@ntlworld.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Alessandro Ghedini <al3xbio@gmail.com>
Subject: [PATCH 2/2] Staging: wlan-ng: fix most of the style issues in hfa384x.h
Date: Sun, 14 Feb 2010 21:12:56 +0100
Message-Id: <1266178376-6763-1-git-send-email-al3xbio@gmail.com>
X-Mailer: git-send-email 1.6.6.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all the errors and the majority of the warnings found with
checkpatch.pl script in hfa384x.h, following Gábor Stefanik hints

Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index 8e39f76..3d440f8 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -63,15 +63,9 @@
 /*--- Mins & Maxs -----------------------------------*/
 #define		HFA384x_PORTID_MAX		((u16)7)
 #define		HFA384x_NUMPORTS_MAX		((u16)(HFA384x_PORTID_MAX+1))
-#define		HFA384x_PDR_LEN_MAX		((u16)512) 	/*
-								 * in bytes,
-								 * from EK
-								 */
+#define		HFA384x_PDR_LEN_MAX	((u16)512) 	/* in bytes, from EK */
 #define		HFA384x_PDA_RECS_MAX		((u16)200)	/* a guess */
-#define		HFA384x_PDA_LEN_MAX		((u16)1024)	/*
-								 * in bytes,
-								 * from EK
-								 */
+#define		HFA384x_PDA_LEN_MAX	((u16)1024)	/* in bytes, from EK*/
 #define		HFA384x_SCANRESULT_MAX		((u16)31)
 #define		HFA384x_HSCANRESULT_MAX		((u16)31)
 #define		HFA384x_CHINFORESULT_MAX	((u16)16)
-- 
1.6.6.2

