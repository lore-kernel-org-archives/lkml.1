Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbXFYJgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbXFYJgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXFYJgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:36:36 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63010 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751889AbXFYJgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:36:35 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-usb-devel@lists.sourceforge.net
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] Export usb_gadgetfs.h to userspace
Date: Mon, 25 Jun 2007 11:29:39 +0200
Message-Id: <11827637791662-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The gadgetfs test program from http://www.linux-usb.org/gadget/
depends on it. I assume most other users of gadgetfs needs this header
too.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index f317c27..b216ee3 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -152,6 +152,7 @@ header-y += tipc.h
 header-y += toshiba.h
 header-y += ultrasound.h
 header-y += un.h
+header-y += usb_gadgetfs.h
 header-y += utime.h
 header-y += video_decoder.h
 header-y += video_encoder.h
-- 
1.5.2.2

