Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXGJMgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXGJMgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXGJMgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:36:23 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38397 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752762AbXGJMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:36:22 -0400
Message-Id: <20070710122702.765654000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 14:27:02 +0200
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

