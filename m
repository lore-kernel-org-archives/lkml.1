Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbZF1OQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbZF1OQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbZF1OOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:14:04 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43467 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbZF1OOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=skkedUWBr9g40qF3Jso71mRYAXznvbv6SzvvuACvE1h1jrpH9NbAiWOxh0E9NQzQpr
         lUajAAz7AnGnW4W1Y+OsoU7Q7HTbtDbhxE83GjcWwiLPBLdDbt/DsSD7uvxZHu6ikFdK
         bgPrnPiMqn7t2atXnyMX8KUTWttQZegQQKRhs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 28 Jun 2009 16:20:23 +0200
Message-Id: <20090628142023.8761.45624.sendpatchset@localhost.localdomain>
In-Reply-To: <20090628141844.8761.8943.sendpatchset@localhost.localdomain>
References: <20090628141844.8761.8943.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/18] Staging: rtl8187se: remove unused definitions from r8180.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se: remove unused definitions from r8180.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/r8180.h |   14 --------------
 1 file changed, 14 deletions(-)

Index: b/drivers/staging/rtl8187se/r8180.h
===================================================================
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -52,30 +52,16 @@
 
 #define DEFAULT_FRAG_THRESHOLD 2342U
 #define MIN_FRAG_THRESHOLD     256U
-//#define	MAX_FRAG_THRESHOLD     2342U
 #define DEFAULT_RTS_THRESHOLD 2342U
 #define MIN_RTS_THRESHOLD 0U
 #define MAX_RTS_THRESHOLD 2342U
 #define DEFAULT_BEACONINTERVAL 0x64U
-#define DEFAULT_BEACON_ESSID "Rtl8180"
 
-#define DEFAULT_SSID ""
 #define DEFAULT_RETRY_RTS 7
 #define DEFAULT_RETRY_DATA 7
-#define PRISM_HDR_SIZE 64
 
-
-#define MGNT_QUEUE						0
-#define BK_QUEUE						1
-#define BE_QUEUE						2
-#define VI_QUEUE						3
-#define VO_QUEUE						4
-#define HIGH_QUEUE						5
 #define BEACON_QUEUE					6
 
-#define LOW_QUEUE						BE_QUEUE
-#define NORMAL_QUEUE					MGNT_QUEUE
-
 #define aSifsTime 	10
 
 #define sCrcLng         4
