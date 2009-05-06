Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbZEFQvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbZEFQvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZEFQvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:51:01 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:58901 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZEFQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:51:00 -0400
Message-ID: <4A01BFCE.6020908@oracle.com>
Date: Wed, 06 May 2009 09:50:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com
Subject: [PATCH] xen: use header for EXPORT_SYMBOL_GPL
References: <200905060438.n464cWFU025212@imap1.linux-foundation.org>
In-Reply-To: <200905060438.n464cWFU025212@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A01BF68.027E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

mmu.c needs to #include module.h to prevent these warnings:

arch/x86/xen/mmu.c:239: warning: data definition has no type or storage class
arch/x86/xen/mmu.c:239: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/x86/xen/mmu.c:239: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/xen/mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-0505-2119.orig/arch/x86/xen/mmu.c
+++ mmotm-2009-0505-2119/arch/x86/xen/mmu.c
@@ -42,6 +42,7 @@
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/bug.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
