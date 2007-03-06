Return-Path: <linux-kernel-owner+w=401wt.eu-S965277AbXCFQco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbXCFQco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXCFQco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:32:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:27620 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965277AbXCFQcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:32:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=H76KtpWt5aPTc49FTgB80kS2j4mJRshMYO+3iaeZ+i1DqrGwq3b8rvmCP/8cFDn0uVvFygZBdjzEBCsmvFnhTfVDOnhsGR1TZPK89p+utQFblJs9fh2fgl0T2iqb6HjBwdI+1iWdETQafFHwOxSX503ebwUkOwVEKQXqKfERKok=
Message-ID: <9c21eeae0703060832g22c12ba7od5abfb5216b0b973@mail.gmail.com>
Date: Tue, 6 Mar 2007 08:32:41 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove availability for PAGE_SIZE and friends (x86-64)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Same patch as the i386 one only for the x86_64 architecture

Thanks,
- David Brown

diff --git a/include/asm-x86_64/page.h b/include/asm-x86_64/page.h
index 10f3461..c5f0097 100644
--- a/include/asm-x86_64/page.h
+++ b/include/asm-x86_64/page.h
@@ -1,6 +1,7 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H

+#ifdef __KERNEL__

 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT     12
@@ -40,7 +41,6 @@
 #define HPAGE_MASK     (~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER     (HPAGE_SHIFT - PAGE_SHIFT)

-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__

 extern unsigned long end_pfn;
