Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbXLSKPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbXLSKPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXLSKPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:15:25 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61270 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751780AbXLSKPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:15:24 -0500
Date: Wed, 19 Dec 2007 11:15:18 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] ps3fb bug fixes for 2.6.24
Message-ID: <Pine.LNX.4.62.0712191105220.16918@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-581292904-1198059318=:16918"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-581292904-1198059318=:16918
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi Linus, Andrew,

Here are 2 bug fixes for the PS3 Virtual Frame Buffer Device Driver:
  [1] ps3fb: Update for firmware 2.10
  [2] ps3fb: Fix ps3fb free_irq() dev_id

The first one fixes a problem with PS3 firmware 2.10 (released yesterday),
which causes a non-working display.

The second one fixes an incorrect dev_id parameter used with the free_irq()
calls.

Please apply for 2.6.24. Thanks!

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
---584337861-581292904-1198059318=:16918--
