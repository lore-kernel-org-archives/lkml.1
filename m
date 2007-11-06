Return-Path: <linux-kernel-owner+w=401wt.eu-S935267AbYBNXre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267AbYBNXre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933381AbYBNXkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:40:36 -0500
Received: from havoc.gtf.org ([69.61.125.42]:60770 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761799AbYBNXkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:40:25 -0500
Message-Id: <3a283f8071d5b47acc5748f336e2c3200b0f0c3f.1203031879.git.jeff@garzik.org>
In-Reply-To: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Date: Tue, 6 Nov 2007 09:41:01 -0500
Subject: [PATCH 14/14] [isdn-pci] add missing file
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

SIDE NOTE -- this obviously needs to be ordered at the beginning of the
patchset.



 drivers/isdn/hisax/hisax_proto.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 drivers/isdn/hisax/hisax_proto.h

diff --git a/drivers/isdn/hisax/hisax_proto.h b/drivers/isdn/hisax/hisax_proto.h
new file mode 100644
index 0000000..7eea361
--- /dev/null
+++ b/drivers/isdn/hisax/hisax_proto.h
@@ -0,0 +1,25 @@
+#ifndef __ISDN_HISAX_HISAX_PROTO_H__
+#define __ISDN_HISAX_HISAX_PROTO_H__
+
+#ifdef CONFIG_HISAX_1TR6
+#define DEFAULT_PROTO ISDN_PTYPE_1TR6
+#define DEFAULT_PROTO_NAME "1TR6"
+#endif
+#ifdef CONFIG_HISAX_NI1
+#undef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_NI1
+#undef DEFAULT_PROTO_NAME
+#define DEFAULT_PROTO_NAME "NI1"
+#endif
+#ifdef CONFIG_HISAX_EURO
+#undef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_EURO
+#undef DEFAULT_PROTO_NAME
+#define DEFAULT_PROTO_NAME "EURO"
+#endif
+#ifndef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_UNKNOWN
+#define DEFAULT_PROTO_NAME "UNKNOWN"
+#endif
+
+#endif /* __ISDN_HISAX_HISAX_PROTO_H__ */
-- 
1.5.3.8

