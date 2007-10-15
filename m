Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbXJOJvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbXJOJvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757762AbXJOJvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:51:13 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41826 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757848AbXJOJvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:51:12 -0400
Date: Mon, 15 Oct 2007 11:51:03 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: [PATCH] PS3 system bus add_uevent_var() fallout
Message-ID: <Pine.LNX.4.62.0710151150090.28206@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1757741-1192441863=:28206"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1757741-1192441863=:28206
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

PS3 system bus add_uevent_var() fallout: kill unused variables

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/platforms/ps3/system-bus.c |    1 -
 1 files changed, 1 deletion(-)

--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -440,7 +440,6 @@ static void ps3_system_bus_shutdown(stru
 static int ps3_system_bus_uevent(struct device *_dev, struct kobj_uevent_env *env)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
-	int i = 0, length = 0;
 
 	if (add_uevent_var(env, "MODALIAS=ps3:%d", dev->match_id))
 		return -ENOMEM;

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
---584337861-1757741-1192441863=:28206--
