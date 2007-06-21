Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbXFUAww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbXFUAww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXFUAwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:52:45 -0400
Received: from ccerelrim02.cce.hp.com ([161.114.21.23]:11575 "EHLO
	ccerelrim02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXFUAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:52:44 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Wed, 20 Jun 2007 20:52:41 -0400
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-06-20-10-12.tar.gz uploaded
Message-ID: <20070621005241.GE10927@localhost>
References: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.6.20.173532
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:	[Wed Jun 20 2007, 01:14:34PM EDT]
[snip] 

More build breakage. efi_range_is_wc is referenced but not declared.


Signed-off-by: Bob Picco <bob.picco@hp.com>

 include/asm-ia64/fb.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22-rc5-mm1/include/asm-ia64/fb.h
===================================================================
--- linux-2.6.22-rc5-mm1.orig/include/asm-ia64/fb.h	2007-06-20 14:09:18.000000000 -0400
+++ linux-2.6.22-rc5-mm1/include/asm-ia64/fb.h	2007-06-20 20:40:48.000000000 -0400
@@ -3,6 +3,7 @@
 
 #include <linux/fb.h>
 #include <linux/fs.h>
+#include <linux/efi.h>
 #include <asm/page.h>
 
 static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
