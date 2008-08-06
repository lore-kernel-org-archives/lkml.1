Return-Path: <linux-kernel-owner+w=401wt.eu-S1764159AbYHFVXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764159AbYHFVXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbYHFVNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:13:35 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59685 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422854AbYHFVNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:13:33 -0400
Date: Thu, 7 Aug 2008 00:12:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make probe_serial_gsc() static
Message-ID: <20080806211205.GY1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global probe_serial_gsc() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 18 Jun 2008

e0053c1295ce33ec15d2788140070660e95a07f0 diff --git a/drivers/serial/8250_gsc.c b/drivers/serial/8250_gsc.c
index 0416ad3..418b4fe 100644
--- a/drivers/serial/8250_gsc.c
+++ b/drivers/serial/8250_gsc.c
@@ -111,7 +111,7 @@ static struct parisc_driver serial_driver = {
 	.probe		= serial_init_chip,
 };
 
-int __init probe_serial_gsc(void)
+static int __init probe_serial_gsc(void)
 {
 	register_parisc_driver(&lasi_driver);
 	register_parisc_driver(&serial_driver);

