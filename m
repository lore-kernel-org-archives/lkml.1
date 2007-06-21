Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXFUC5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXFUC5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 22:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXFUC46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 22:56:58 -0400
Received: from gw.goop.org ([64.81.55.164]:41228 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbXFUC45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 22:56:57 -0400
Message-ID: <4679E8B0.2070806@goop.org>
Date: Wed, 20 Jun 2007 19:55:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-06-20-10-12.tar.gz uploaded
References: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
In-Reply-To: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> i386-minor-nx-handling-adjustment.patch
>   

This is needed:

Include asm/pgtable.h to get declaration of __supported_pte_mask

This fixes problem exposed by i386-minor-nx-handling-adjustment.patch

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/xen/page.h |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/include/xen/page.h
+++ b/include/xen/page.h
@@ -4,6 +4,7 @@
 #include <linux/pfn.h>
 
 #include <asm/uaccess.h>
+#include <asm/pgtable.h>
 
 #include <xen/features.h>
 


