Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYGXXQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYGXXQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYGXXQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:16:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15634 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbYGXXQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:16:25 -0400
Date: Thu, 24 Jul 2008 16:09:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: vegardno@ifi.uio.no, penberg@cs.helsinki.fi,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] kmemcheck: include module.h to prevent warnings
Message-Id: <20080724160932.cdcf4927.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

kmemcheck/shadow.c needs to include <linux/module.h> to prevent
the following warnings:

linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : data definition has no type or storage class
linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/mm/kmemcheck/shadow.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20080724.orig/arch/x86/mm/kmemcheck/shadow.c
+++ linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c
@@ -1,5 +1,6 @@
 #include <linux/kmemcheck.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
