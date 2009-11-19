Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZKSIdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZKSIdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZKSIdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:33:03 -0500
Received: from ozlabs.org ([203.10.76.45]:39613 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZKSIdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:33:02 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tim Abbott <tabbott@ksplice.com>
Subject: Licensing on lib/bsearch.c?
Date: Thu, 19 Nov 2009 19:03:04 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: =?iso-8859-1?q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191903.04915.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim, Andre,

   I note that the license header on lib/bsearch.c is GPLv2.  I wanted to
steal it for SAMBA, which is GPLv3.  This is one reason all my kernel code is
v2 or later.

If you don't have strong objections, could you send something like the
following so I don't have to reimplement and re-test?

Thanks,
Rusty.

Subject: bsearch: extend license to GPL 2+

Rusty asked nicely.

diff --git a/lib/bsearch.c b/lib/bsearch.c
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -6,7 +6,8 @@
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; version 2.
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
  */
 
 #include <linux/module.h>
