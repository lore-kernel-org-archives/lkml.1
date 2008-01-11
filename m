Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYAKN2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYAKN2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 08:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760180AbYAKN2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 08:28:23 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:44007 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760795AbYAKN2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 08:28:21 -0500
Date: Fri, 11 Jan 2008 14:26:03 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Jeremy Kerr <jk@ozlabs.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] ps3fb fixes for 2.6.24
Message-ID: <Pine.LNX.4.64.0801111417450.12038@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1758595838-1200057963=:12038"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---584349381-1758595838-1200057963=:12038
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi Linus, Andrew,

Here are 2 more fixes for ps3fb:
  [1] ps3fb: prevent use after free of fb_info
  [2] ps3fb: fix deadlock on kexec()

The first one fixes a potential use after free.
The second one fixes a lockup when using kexec or shutdown while /dev/fb0 is
open (e.g. when using the petitboot graphical bootloader to load the second
stage kernel).

Can we please get these in 2.6.24? Thanks!

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
---584349381-1758595838-1200057963=:12038--
