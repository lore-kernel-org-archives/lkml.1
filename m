Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbXFCOmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbXFCOmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbXFCOkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:40:37 -0400
Received: from web50102.mail.re2.yahoo.com ([206.190.38.30]:33985 "HELO
	web50102.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752985AbXFCOkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:40:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=yciaOG+uDshi/w/4rWuKU9fPWRo9T7IKwZ0pBnY9WzqAjCtumReJby9X2XxDdRwokkmCYXuwNnCzw025/8vtlwoaQc11i1uWkzONB53lmJu7dTHvxjBAmMoy5+mTazZsSN9c1NqTi4cSHi53mc+WMcikjOLOZPHrxkCEUBCeg20=;
X-YMail-OSG: AcSyCe4VM1nh3mFyA6H4fuvC0S9ib_7BvPEs8e9cn5B1x49uKfn4zbLRy_D5atOM7TycZzJ4cOu.d1urqhx4biOxe6TY5K8qwvcJ7XVxUclZ9BiEuKELF_vKhw2EGAUjA63yeFTi
Date: Sun, 3 Jun 2007 07:40:34 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 10/36] drivers edac fix core.h scrubdefs
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <479922.77410.qm@web50102.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Patch to fix some scrubbing #defines in the edac_core.h file

Signed-off-by:  Douglas Thompson <dougthompson@xmission.com>
--
 edac_core.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
--
Index: linux-2.6.21.1/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.21.1.orig/drivers/edac/edac_core.h
+++ linux-2.6.21.1/drivers/edac/edac_core.h
@@ -194,12 +194,12 @@ enum scrub_type {
 };
 
 #define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
-#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC_CORR)
-#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC_CORR)
+#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC)
+#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC)
 #define SCRUB_FLAG_SW_TUN	BIT(SCRUB_SW_SCRUB_TUNABLE)
 #define SCRUB_FLAG_HW_PROG	BIT(SCRUB_HW_PROG)
-#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC_CORR)
-#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC_CORR)
+#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC)
+#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC)
 #define SCRUB_FLAG_HW_TUN	BIT(SCRUB_HW_TUNABLE)
 
 /* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */

