Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYA3KNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYA3KNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYA3KNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:13:32 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42377 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754579AbYA3KNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:13:31 -0500
Date: Wed, 30 Jan 2008 11:13:23 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: kbuild: Spelling/grammar fixes for config DEBUG_SECTION_MISMATCH
Message-ID: <Pine.LNX.4.64.0801301112550.26678@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1508965004-1201688003=:26678"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1508965004-1201688003=:26678
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

kbuild: Spelling/grammar fixes for config DEBUG_SECTION_MISMATCH

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 lib/Kconfig.debug |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -90,19 +90,19 @@ config DEBUG_SECTION_MISMATCH
 	  most likely result in an oops.
 	  In the code functions and variables are annotated with
 	  __init, __devinit etc. (see full list in include/linux/init.h)
-	  which result in the code/data being placed in specific sections.
-	  The section mismatch anaylsis are always done after a full
+	  which results in the code/data being placed in specific sections.
+	  The section mismatch analysis is always done after a full
 	  kernel build but enabling this options will in addition
 	  do the following:
 	  - Add the option -fno-inline-functions-called-once to gcc
 	    When inlining a function annotated __init in a non-init
 	    function we would loose the section information and thus
 	    the analysis would not catch the illegal reference.
-	    This options tell gcc to inline less but will also
+	    This option tells gcc to inline less but will also
 	    result in a larger kernel.
 	  - Run the section mismatch analysis for each module/built-in.o
 	    When we run the section mismatch analysis on vmlinux.o we
-	    looses valueable information about where the mismatch was
+	    loose valueable information about where the mismatch was
 	    introduced.
 	    Running the analysis for each module/built-in.o file
 	    will tell where the mismatch happens much closer to the

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-1508965004-1201688003=:26678--
