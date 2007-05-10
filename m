Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbXEJDNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbXEJDNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbXEJDNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:13:04 -0400
Received: from mail.sjtu.org ([202.120.5.34]:7561 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752055AbXEJDNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:13:02 -0400
Subject: [PATCH 3/3] v4l: enlarge the size of ir-key table to 256
From: Tony Wan <wankai@sjtu.org>
To: mchehab@infradead.org, michael@mihu.de
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 10 May 2007 11:05:39 +0800
Message-Id: <1178766340.29993.44.camel@wankai.sjtu.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
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
-#define IR_KEYTAB_SIZE	128  // enougth for rc5, probably need more some
day ...
+#define IR_KEYTAB_SIZE	256  // some remote needs 8-bit keycodes
 
 #define IR_KEYCODE(tab,code)	(((unsigned)code < IR_KEYTAB_SIZE) \
 				 ? tab[code] : KEY_RESERVED)


