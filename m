Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbYDNT6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbYDNT6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761370AbYDNT5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:57:15 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38720 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761357AbYDNT5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:57:14 -0400
Date: Mon, 14 Apr 2008 22:56:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] serial/8250_gsc.c: add MODULE_LICENSE
Message-ID: <20080414195608.GF26885@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
c0d845566182db3fc650dcfa35700f84e82bbae7 diff --git a/drivers/serial/8250_gsc.c b/drivers/serial/8250_gsc.c
index 4eb7437..0416ad3 100644
--- a/drivers/serial/8250_gsc.c
+++ b/drivers/serial/8250_gsc.c
@@ -119,3 +119,5 @@ int __init probe_serial_gsc(void)
 }
 
 module_init(probe_serial_gsc);
+
+MODULE_LICENSE("GPL");

