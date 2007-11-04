Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbXKDPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbXKDPL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbXKDPLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:11:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:6237 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbXKDPLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:11:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CtgNhi67n4glAKwl4dLn5zIdD7q5a6/3/6Jmz/3JT2X6LpHzaSgCTjn1RCYIJxgvfQ8MTVzPgFXchwj8WMy8vkUXHsgm+95Yw02Kd93Y5T0EGvWRnWV69kDs/YjI5wInAXLamvU5seFMLJXA+SkHxvb+6hJbZRSa+HrQNCjNPKY=
Message-ID: <e5bfff550711040711g4e8a6efbn1d26b4c332c0a312@mail.gmail.com>
Date: Sun, 4 Nov 2007 16:11:49 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Remove duplicated include under net/ directory
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marco Costalba <mcostalba@gmail.com>
---
 net/core/dst.c                       |    1 -
 net/ieee80211/ieee80211_crypt_tkip.c |    1 -
 net/ieee80211/ieee80211_crypt_wep.c  |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index 16958e6..10d1339 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -16,7 +16,6 @@
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/types.h>
-#include <net/net_namespace.h>

 #include <net/net_namespace.h>
 #include <net/dst.h>
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c
b/net/ieee80211/ieee80211_crypt_tkip.c
index 4cce353..58b2261 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -25,7 +25,6 @@
 #include <net/ieee80211.h>

 #include <linux/crypto.h>
-#include <linux/scatterlist.h>
 #include <linux/crc32.h>

 MODULE_AUTHOR("Jouni Malinen");
diff --git a/net/ieee80211/ieee80211_crypt_wep.c
b/net/ieee80211/ieee80211_crypt_wep.c
index 866fc04..3fa30c4 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -22,7 +22,6 @@
 #include <net/ieee80211.h>

 #include <linux/crypto.h>
-#include <linux/scatterlist.h>
 #include <linux/crc32.h>

 MODULE_AUTHOR("Jouni Malinen");
-- 
1.5.3.5.532.g5c38-dirty
