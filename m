Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYJaTYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYJaTYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYJaTYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:24:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:54464 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYJaTYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XOchI789R8xFpc1ZrK8EIazV5ZRCVtL67a+vgabKhcdj5rJUzqu+Z931G+p2+shXk2
         9HQ+Ljn4d9jZogIOyHUmQaU/VjJIcQcKG6nEgwjOLmZ7EJTa1cQlMwze9B26Jh30FGxr
         97p2ut2XBO7UA3N2L0FD9Rzvf289Bw3TKnhVo=
Date: Fri, 31 Oct 2008 22:23:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Aristeu Rozanski <aris@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: nmi - document lapic and ioapic parameters
Message-ID: <20081031192358.GC20803@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

On top of -tip dda51106620c328b50007c259b9ef8cea2b7c3d2

Index: linux-2.6.git/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.git.orig/Documentation/kernel-parameters.txt	2008-10-27 21:35:08.000000000 +0300
+++ linux-2.6.git/Documentation/kernel-parameters.txt	2008-10-31 22:21:59.000000000 +0300
@@ -1404,6 +1404,14 @@ and is between 256 and 4096 characters. 
 			Format: [state][,regs][,debounce][,die]
 
 	nmi_watchdog=	[KNL,BUGS=X86-32] Debugging features for SMP kernels
+			Format: [panic,][num]
+			Valid num: 0,1,2
+			0 - turn nmi_watchdog off
+			1 - use IO-APIC
+			2 - use local APIC
+			Instead of 1 and 2 it is possible to use the following
+			symbolic names: lapic and ioapic
+			Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
 
 	no387		[BUGS=X86-32] Tells the kernel to use the 387 maths
 			emulation library even if a 387 maths coprocessor
