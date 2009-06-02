Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZFBOD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZFBOD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZFBODR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:03:17 -0400
Received: from mfow301.po.2iij.NET ([210.128.50.233]:33565 "EHLO
	mfow.po.2iij.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbZFBODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:03:17 -0400
X-Greylist: delayed 814 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 10:03:16 EDT
Date: Tue, 2 Jun 2009 22:49:36 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: yoichi_yuasa@tripeaks.co.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix typo in asm-generic/gpio.h
Message-Id: <20090602224936.8fb94b29.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d6c379d..2a37611 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -53,7 +53,7 @@ struct module;
  *	negative during registration, requests dynamic ID allocation.
  * @ngpio: the number of GPIOs handled by this controller; the last GPIO
  *	handled is (base + ngpio - 1).
- * @can_sleep: flag must be set iff get()/set() methods sleep, as they
+ * @can_sleep: flag must be set if get()/set() methods sleep, as they
  *	must while accessing GPIO expander chips over I2C or SPI
  * @names: if set, must be an array of strings to use as alternative
  *      names for the GPIOs in this chip. Any entry in the array
