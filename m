Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbXK1Ofd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbXK1Ofd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXK1OfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:35:23 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62238 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755978AbXK1OfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:35:22 -0500
Message-Id: <20071128143142.580732000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 15:31:42 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [patch 0/7] PS3 notification device patches for 2.6.25
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

Here are my PS3 notification device patches for 2.6.25:
  [1] ps3: Make bus_id and dev_id u64
  [2] ps3: Add ps3_repository_find_device_by_id()
  [3] ps3: Use the HV's storage device notification mechanism properly
  [4] ps3: Add repository polling loop to work around hypervisor bug
  [5] ps3: Kill unused ps3_repository_bump_device()
  [6] ps3: Refactor ps3_repository_find_device()
  [7] ps3: denoise arch/powerpc/platforms/ps3/repository.c

These patches correct the use of the PS3 notification device mechanism, which
allows to wait until a storage device is ready.

Please review, thanks!

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

