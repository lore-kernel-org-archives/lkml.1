Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbXGKDZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbXGKDZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 23:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbXGKDZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 23:25:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:40334 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbXGKDZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 23:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ooFoajckRl+QSV0fEF5Lhl/A9/muVIf6H25xeSNhwYfgx/U0dFRiMUgRLIU4h+9B9vh1zqRuce7e1UWxPcC+7DE+GHsYPeYen2dLabxvy20bl2c0Xb1dapcpNvov2sXjDJGrPAy+KFQFhUtGKFmwRl6jMAEVvD2uX/NqIyHUu18=
Date: Wed, 11 Jul 2007 11:25:35 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][DOC]hpet.txt broken link fix
Message-ID: <20070711112535.GA13395@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, randy

how about remove the spec links in the header files as well.

Subject:
Remove document links in hpet header files.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

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
