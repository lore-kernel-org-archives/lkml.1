Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYGWOo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYGWOo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYGWOot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:44:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:42025 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYGWOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=S1xG337NuNaIEWN6UupqEd6DyJGaqCAbLqBOjA5sdRWEtUxC7TtiFqnMkeTG+ZEODK
         OdMvi0j5sH7oi05nRxQw9C1L23NRF7wAZA+2cT8mqZFPWY9JrauW6BjQrwLRrNx1dobL
         48Hq0vEpzt1IOxPdCINxdqGGKgOz2MZ7G7yS0=
Date: Wed, 23 Jul 2008 22:44:48 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: p_gortmaker@yahoo.com
Subject: arch/m68k/bvme6000/rtc.c: Removed duplicated include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080723212907.940D.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6NEj8fq003834

Removed duplicated include file <linux/smp_lock.h> in
arch/m68k/bvme6000/rtc.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/m68k/bvme6000/rtc.c b/arch/m68k/bvme6000/rtc.c
index e8ac3f7..24d848b 100644
--- a/arch/m68k/bvme6000/rtc.c
+++ b/arch/m68k/bvme6000/rtc.c
@@ -18,7 +18,6 @@
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/mc146818rtc.h> /* For struct rtc_time and ioctls, etc */
-#include <linux/smp_lock.h>
 #include <linux/bcd.h>
 #include <asm/bvme6000hw.h>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
