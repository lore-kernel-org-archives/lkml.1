Return-Path: <linux-kernel-owner+w=401wt.eu-S936264AbXGMIwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936264AbXGMIwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762643AbXGMIwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:52:17 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45521 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760620AbXGMIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:52:16 -0400
Date: Fri, 13 Jul 2007 10:52:10 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Antonino A. Daplas" <adaplas@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 0/4] Cell SPE logos
In-Reply-To: <20070712160621.644d78d2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.62.0707131051190.18802@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
 <20070712160621.644d78d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-588761602-1184316730=:18802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-588761602-1184316730=:18802
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 12 Jul 2007, Andrew Morton wrote:
> On Tue, 10 Jul 2007 14:27:02 +0200
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> > The Cell Broadband Engine contains a 64-bit PowerPC core with 2 hardware
> > threads (called PPEs) and 8 Synergistic Processing Engines (called SPEs).
> > When booting Linux, 2 penguins logos are shown on the graphical console by
> > the standard frame buffer console logo code.
> > 
> > To emphasize the existence of the SPEs (which can be used under Linux), we
> > added a second row of (smaller) helper penguin logos, one for each SPE.
> > 
> > A sample screenshot can be found at
> > http://www.kernel.org/pub/linux/kernel/people/geoff/cell/debian-penguin-shot.png
> > (or on the ps3linux T-shirts we wore at OLS :-)
> 
> Does this mean I'll get penguins on my PS3 now?

Sure!

> > Summaries:
> >   [1] fbdev: extract fb_show_logo_line()
> >   [2] fbdev: Add fb_append_extra_logo()
> 
> This one does give additional code and data to all fbdev users while only
> being useful to cell machines.  Should we fix that?

I can protect it by #ifdef CONFIG_PPC_CELL (as long as there are no other
users). Would that be OK?

> >   [3] fbdev: SPE helper penguin logo
> >   [4] Cell: Draw SPE helper penguin logos
> 
> I queued #4 up along with the fbdev patches, even though it isn't really an
> fbdev patch.

OK, thanks!

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
---584337861-588761602-1184316730=:18802--
