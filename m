Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbXEJJ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbXEJJ5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXEJJ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:57:00 -0400
Received: from mr.exanet.com ([212.143.73.109]:37195 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759940AbXEJJ47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:56:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] NLM program ID for user space NLM server
Date: Thu, 10 May 2007 12:56:50 +0300
Message-ID: <A6FDE6B975803043804A49F12F49028E0F59C7@hawk.exanet-il.co.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NLM program ID for user space NLM server
Thread-Index: AceS6YdMabkqvU84RzecW+9AQjdfRw==
From: "Menny Hamburger" <menny@exanet.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the current kernel cannot be compiled with NFS client and without
lockd, it is not possible to register a user space NLM server
Without colliding with the kernel service registered in
.../fs/lockd/lockd.c.

This simple patch gives the ability to provide NLM_PROGRAM from outside:
--- linux-2.6.20/include/linux/lockd/nlm.h	2007-02-04
20:44:54.000000000 +0200
+++ linux-2.6.20_patched/include/linux/lockd/nlm.h	2007-05-10
12:21:40.799004000 +0300
@@ -30,7 +30,9 @@
 #endif
 };
 
+#ifndef 
 #define NLM_PROGRAM		100021
+#endif
 
 #define NLMPROC_NULL		0
 #define NLMPROC_TEST		1

Menny

