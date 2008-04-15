Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbYDOJET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbYDOJET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbYDOJEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:04:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52514 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbYDOJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:04:07 -0400
Date: Tue, 15 Apr 2008 12:04:04 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] smb.h: uses struct timespec but didn't include linux/time.h
Message-ID: <Pine.LNX.4.64.0804151202390.17123@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1069186259-1208250244=:17123"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1069186259-1208250244=:17123
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/linux/smb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/smb.h b/include/linux/smb.h
index f098dff..caa43b2 100644
--- a/include/linux/smb.h
+++ b/include/linux/smb.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <linux/time.h>
 
 enum smb_protocol { 
 	SMB_PROTOCOL_NONE, 
-- 
1.5.2.2

---696208474-1069186259-1208250244=:17123--
