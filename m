Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYDWJzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYDWJzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbYDWJvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:38 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36862 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbYDWJvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:37 -0400
Date: Wed, 23 Apr 2008 12:50:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: [2.6 patch] serial/8250_gsc.c: add MODULE_LICENSE
Message-ID: <20080423095057.GU28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Alan Cox <alan@redhat.com>

---

This patch has been sent on:
- 14 Apr 2008

c0d845566182db3fc650dcfa35700f84e82bbae7 diff --git a/drivers/serial/8250_gsc.c b/drivers/serial/8250_gsc.c
index 4eb7437..0416ad3 100644
--- a/drivers/serial/8250_gsc.c
+++ b/drivers/serial/8250_gsc.c
@@ -119,3 +119,5 @@ int __init probe_serial_gsc(void)
 }
 
 module_init(probe_serial_gsc);
+
+MODULE_LICENSE("GPL");

