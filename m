Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYH1OAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYH1OAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYH1OAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:00:25 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:59470 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYH1OAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:00:24 -0400
Date: Thu, 28 Aug 2008 11:00:07 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: mingo@elte.hu
Cc: macro@linux-mips.org, linux-kernel@vger.kernel.org
Subject: PATCH: Remove 8254 timer texts from Documentation
Message-ID: <20080828110007.69674b06@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit ecd29476ae0143b1c3641edfa76c0fc3e9ad3021 removed the
"disable_8254_timer" and "enable_8254_timer" kernel parameters from
the kernel but did not remove the references to them from two
files in the Documentation directory: kernel-parameters.txt and
x86/x86_64/boot-options.txt.

This change completes the removal.

Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
---
 Documentation/kernel-parameters.txt       |    6 ------
 Documentation/x86/x86_64/boot-options.txt |    4 ----
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1150444..dccd483 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -463,12 +463,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			Range: 0 - 8192
 			Default: 64
 
-	disable_8254_timer
-	enable_8254_timer
-			[IA32/X86_64] Disable/Enable interrupt 0 timer routing
-			over the 8254 in addition to over the IO-APIC. The
-			kernel tries to set a sensible default.
-
 	hpet=		[X86-32,HPET] option to control HPET usage
 			Format: { enable (default) | disable | force }
 			disable: disable HPET and use PIT instead
diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index b0c7b6c..72ffb53 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -54,10 +54,6 @@ APICs
 		 apicmaintimer. Useful when your PIT timer is totally
 		 broken.
 
-   disable_8254_timer / enable_8254_timer
-		 Enable interrupt 0 timer routing over the 8254 in addition to over
-	         the IO-APIC. The kernel tries to set a sensible default.
-
 Early Console
 
    syntax: earlyprintk=vga
-- 
1.5.6



-- 
Luiz Fernando N. Capitulino
