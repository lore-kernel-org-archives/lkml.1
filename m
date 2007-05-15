Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbXEOBSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbXEOBSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 21:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbXEOBSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 21:18:24 -0400
Received: from ozlabs.org ([203.10.76.45]:33415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbXEOBSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 21:18:23 -0400
Subject: [PATCH 2/6] lguest: kbuild tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1179191827.10836.24.camel@localhost.localdomain>
References: <1179191827.10836.24.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 15 May 2007 11:18:08 +1000
Message-Id: <1179191888.10836.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg says lg-objs is deprecated, use lg-y.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/drivers/lguest/Makefile
+++ b/drivers/lguest/Makefile
@@ -3,5 +3,5 @@ obj-$(CONFIG_LGUEST_GUEST) += lguest.o l
 
 # Host requires the other files, which can be a module.
 obj-$(CONFIG_LGUEST)	+= lg.o
-lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+lg-y := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
 	segments.o io.o lguest_user.o switcher.o


