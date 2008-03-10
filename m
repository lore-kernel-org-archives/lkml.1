Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYCJXgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYCJXgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYCJXeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:34:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13475 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYCJXej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=uRnsBuTzXVEasFHi9ILu0pW545krJ/jhqJh84fd019ZPeDKsa8PKQaSTicYeCeyMo4IbCoK9mciJtg2K7NU00sKCgdlX3gZj5UxSMvxivVgXqS6ZfdvTOZx4L21xaRI2olzUlGzFo34OzkD4q3B9Wk0BX8KYk1SKmOHReChXcJk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/5] ide: mark special "ide0=" kernel parameters as obsoleted
Date: Tue, 11 Mar 2008 00:46:37 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803110046.37923.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark "ide0=ali14xx|cmd640_vlb|dtc2278|ht6560b|qd65xx|umc8672" kernel
parameters as obsoleted (per host driver replacements have been available
for a long time).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1038,32 +1038,32 @@ static int __init ide_setup(char *s)
 #ifdef CONFIG_BLK_DEV_ALI14XX
 			case -17: /* "ali14xx" */
 				probe_ali14xx = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_UMC8672
 			case -16: /* "umc8672" */
 				probe_umc8672 = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_DTC2278
 			case -15: /* "dtc2278" */
 				probe_dtc2278 = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_CMD640
 			case -14: /* "cmd640_vlb" */
 				cmd640_vlb = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_HT6560B
 			case -13: /* "ht6560b" */
 				probe_ht6560b = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_QD65XX
 			case -12: /* "qd65xx" */
 				probe_qd65xx = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_4DRIVES
 			case -11: /* "four" drives on one set of ports */
