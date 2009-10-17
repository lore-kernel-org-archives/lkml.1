Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZJQAtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZJQAtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZJQAtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:49:03 -0400
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:47417 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750791AbZJQAtC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:49:02 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] security/min_addr.c: make init_mmap_min_addr() static
Date: Fri, 16 Oct 2009 20:49:05 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901E24570@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] security/min_addr.c: make init_mmap_min_addr() static
Thread-Index: AcpOw6DSlZ44qRUdRzWiyZVioHl3nA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Oct 2009 00:49:05.0663 (UTC) FILETIME=[A0C980F0:01CA4EC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_mmap_min_addr() is a pure_initcall and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/security/min_addr.c b/security/min_addr.c
index c844eed..e92cc99 100644
--- a/security/min_addr.c
+++ b/security/min_addr.c
@@ -40,7 +40,7 @@ int mmap_min_addr_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
-int __init init_mmap_min_addr(void)
+static int __init init_mmap_min_addr(void)
 {
 	update_mmap_min_addr();
  
