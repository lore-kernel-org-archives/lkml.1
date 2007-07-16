Return-Path: <linux-kernel-owner+w=401wt.eu-S1765094AbXGPOBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765094AbXGPOBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760153AbXGPOAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:00:53 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42184 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759920AbXGPOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:00:52 -0400
Message-Id: <20070716135550.010775000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jul 2007 15:55:50 +0200
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/4] Cell SPE logos
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Cell Broadband Engine contains a 64-bit PowerPC core with 2 hardware
threads (called PPEs) and 8 Synergistic Processing Engines (called SPEs).
When booting Linux, 2 penguins logos are shown on the graphical console by
the standard frame buffer console logo code.

To emphasize the existence of the SPEs (which can be used under Linux), we
added a second row of (smaller) helper penguin logos, one for each SPE.

A sample screenshot can be found at
http://www.kernel.org/pub/linux/kernel/people/geoff/cell/debian-penguin-shot.png
(or on the ps3linux T-shirts we wore at OLS :-)

Summaries:
  [1] fbdev: extract fb_show_logo_line()
  [2] fbdev: Add fb_append_extra_logo()
  [3] fbdev: SPE helper penguin logo
  [4] Cell: Draw SPE helper penguin logos

Compared to the previous submission, patches 2 and 4 were modified (cfr. the
changelogs in those patches).

Thanks for applying!

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

