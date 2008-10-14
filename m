Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYJNXaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYJNXaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYJNX36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:29:58 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:59524 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYJNX36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=M/RL+n8o+QKgbbd/YE9QRGhTvKh9L9ZCj4ClX0S2/NQWEhIJWSl9Q9U7aHW1Erf7iu
         U6Rr7UJKK5rQiVByk5ftTsXo7flIXLNnqpdFrjAk1FEl78Pp/jYfx/wpKyPQ6kKWg4Iw
         10ge5OZDbxanHg097VD+210e+xwGOb+PTKgcQ=
Date: Wed, 15 Oct 2008 07:29:49 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: p_gortmaker@yahoo.com
Subject: m68k: remove duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081015072826.7144.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated include <linux/smp_lock.h> in
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

