Return-Path: <linux-kernel-owner+w=401wt.eu-S936260AbXGMJKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936260AbXGMJKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbXGMJJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:09:51 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45805 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756503AbXGMJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:09:50 -0400
Date: Fri, 13 Jul 2007 11:09:48 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Antonino A. Daplas" <adaplas@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 0/4] Cell SPE logos
In-Reply-To: <20070713020621.e8f2e4ce.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.62.0707131108320.18802@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
 <20070712160621.644d78d2.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707131051190.18802@pademelon.sonytel.be>
 <20070713020621.e8f2e4ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1293754850-1184317788=:18802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1293754850-1184317788=:18802
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jul 2007, Andrew Morton wrote:
> On Fri, 13 Jul 2007 10:52:10 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> > > > Summaries:
> > > >   [1] fbdev: extract fb_show_logo_line()
> > > >   [2] fbdev: Add fb_append_extra_logo()
> > > 
> > > This one does give additional code and data to all fbdev users while only
> > > being useful to cell machines.  Should we fix that?
> > 
> > I can protect it by #ifdef CONFIG_PPC_CELL (as long as there are no other
> > users). Would that be OK?
> 
> umm, your call.  If that makes sense, sure.

I just don't like putting platform-specific checks in common code.

Perhaps I better add CONFIG_FB_LOGO_EXTRA and make it depend on
CONFIG_PPC_CELL?

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
---584337861-1293754850-1184317788=:18802--
