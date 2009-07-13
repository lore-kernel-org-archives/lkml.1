Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZGMSIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZGMSIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZGMSIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:08:51 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57004 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbZGMSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Aq+HgEloS5aLtbke978iXQa4QXpvuWOdMyAJbPhsqeOvOC9RvAUYcEIss/kusjjMm2
         83SbnA/vwspCGaSFZPAjew9bmnY00LqJkh4oq0jHum4xBm8d4Ef6xPTRa87NWRc/Wp6z
         TUKbiE3TXL78d2XytLoBrUhxzUnpLqft+eg2U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:14:08 +0200
Message-Id: <20090713181408.16765.26642.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
References: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/10] Staging: rtl8192su/ieee80211: remove superfluous container_of definition
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8192su/ieee80211: remove superfluous container_of definition

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/TODO                  |    1 -
 drivers/staging/rtl8192su/ieee80211/ieee80211.h |   14 --------------
 2 files changed, 15 deletions(-)

Index: b/drivers/staging/rtl8192su/TODO
===================================================================
--- a/drivers/staging/rtl8192su/TODO
+++ b/drivers/staging/rtl8192su/TODO
@@ -1,6 +1,5 @@
 TODO:
 - prepare private ieee80211 stack for merge with rtl8187se's version:
-  - remove superflous container_of definition from ieee80211.h
   - remove rtl8192su's specific dead code
   - cleanup ieee80211.h
   - move rtl8192su's specific code out from ieee80211.h
Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211.h
@@ -47,20 +47,6 @@
 #define IWEVCUSTOM 0x8c02
 #endif
 
-#ifndef container_of
-/**
- * container_of - cast a member of a structure out to the containing structure
- *
- * @ptr:        the pointer to the member.
- * @type:       the type of the container struct this is embedded in.
- * @member:     the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({                      \
-        const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
-        (type *)( (char *)__mptr - offsetof(type,member) );})
-#endif
-
 #define KEY_TYPE_NA		0x0
 #define KEY_TYPE_WEP40 		0x1
 #define KEY_TYPE_TKIP		0x2
