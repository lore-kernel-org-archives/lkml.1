Return-Path: <linux-kernel-owner+w=401wt.eu-S964899AbXGTAtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899AbXGTAtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932663AbXGTAsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:48:07 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:26040 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938113AbXGTAsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=PKL4c+TG4XqtLDcX0JtAclqlA8HUy0QzBiJG4lL2uUMPuytLyCBE47PJ/pBAPSJJJby6H3XtUSg+nt5NqXA6e5TQmb0/HOoMI7SnHecjeNfd+s4QXr6hfWnyL05t2nrXUSxraKhTuO5El+8/E3JbULVP2HylN5zSD+C5DDNIwdI=
Date: Fri, 20 Jul 2007 08:45:10 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH][resend] Remove spec doc links in hpet header files
Message-ID: <20070720084510.GA1779@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The links are broken, and already exist in Documentation/hpet.txt, so
remove them for header files.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
include/asm-i386/hpet.h   |    6 ------
include/asm-x86_64/hpet.h |    6 ------
2 files changed, 12 deletions(-)

diff -pur linux/include/asm-i386/hpet.h linux.new/include/asm-i386/hpet.h
--- linux/include/asm-i386/hpet.h	2007-07-11 11:15:42.000000000 +0000
+++ linux.new/include/asm-i386/hpet.h	2007-07-11 11:16:51.000000000 +0000
@@ -28,12 +28,6 @@
 
 #include <linux/timex.h>
 
-/*
- * Documentation on HPET can be found at:
- *      http://www.intel.com/ial/home/sp/pcmmspec.htm
- *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
- */
-
 #define HPET_MMAP_SIZE	1024
 
 #define HPET_ID		0x000
diff -pur linux/include/asm-x86_64/hpet.h linux.new/include/asm-x86_64/hpet.h
--- linux/include/asm-x86_64/hpet.h	2007-07-11 11:16:07.000000000 +0000
+++ linux.new/include/asm-x86_64/hpet.h	2007-07-11 11:17:03.000000000 +0000
@@ -1,12 +1,6 @@
 #ifndef _ASM_X8664_HPET_H
 #define _ASM_X8664_HPET_H 1
 
-/*
- * Documentation on HPET can be found at:
- *      http://www.intel.com/ial/home/sp/pcmmspec.htm
- *      ftp://download.intel.com/ial/home/sp/mmts098.pdf
- */
-
 #define HPET_MMAP_SIZE	1024
 
 #define HPET_ID		0x000
