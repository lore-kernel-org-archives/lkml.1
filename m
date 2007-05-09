Return-Path: <linux-kernel-owner+w=401wt.eu-S970434AbXEIAVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970434AbXEIAVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934941AbXEIAVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:21:21 -0400
Received: from mail.sjtu.org ([202.120.5.34]:40024 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113AbXEIAVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:21:19 -0400
X-Greylist: delayed 1949 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 20:21:12 EDT
Subject: [PATCH 3/3] v4l: Enlarge the size of IR-KEY table to 256
From: Tony Wan <wankai@sjtu.org>
To: michael@mihu.de, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 09 May 2007 15:50:01 +0800
Message-Id: <1178697001.30673.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some IR-remote will produce key codes larger than 128. Enlarge the size
IR_KEYTAB_SIZE to 256 to enable all the keys.

Signed-off-by: Tony Wan <wankai@sjtu.org>
---
 include/media/ir-common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 4e4d207..5355ebc 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -31,7 +31,7 @@
 #define IR_TYPE_OTHER  99
 
 #define IR_KEYTAB_TYPE	u32
-#define IR_KEYTAB_SIZE	128  // enougth for rc5, probably need more some day ...
+#define IR_KEYTAB_SIZE	256  // some remote needs 8-bit keycodes
 
 #define IR_KEYCODE(tab,code)	(((unsigned)code < IR_KEYTAB_SIZE) \
 				 ? tab[code] : KEY_RESERVED)


