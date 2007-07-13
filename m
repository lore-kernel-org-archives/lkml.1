Return-Path: <linux-kernel-owner+w=401wt.eu-S935825AbXGMG6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935825AbXGMG6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935425AbXGMG6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:58:18 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43959 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935268AbXGMG6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:58:17 -0400
Date: Fri, 13 Jul 2007 08:58:15 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 2/4] fbdev: Add fb_append_extra_logo()
In-Reply-To: <1184285757.4566.11.camel@daplas>
Message-ID: <Pine.LNX.4.62.0707130857350.15603@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
 <20070710123540.678435000@pademelon.sonytel.be> <1184285757.4566.11.camel@daplas>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-975467389-1184309895=:15603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-975467389-1184309895=:15603
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jul 2007, Antonino A. Daplas wrote:
> On Tue, 2007-07-10 at 14:27 +0200, Geert Uytterhoeven wrote:
> > --- a/include/linux/linux_logo.h
> > +++ b/include/linux/linux_logo.h
> > @@ -33,5 +33,13 @@ struct linux_logo {
> >  };
> >  
> >  extern const struct linux_logo *fb_find_logo(int depth);
> > +#if defined(CONFIG_LOGO) && defined(CONFIG_FB)
> 
> The CONFIG_LOGO is also probably redundant, but that's arguable.

You can have CONFIG_LOGO without CONFIG_FB (depends on FB ||
SGI_NEWPORT_CONSOLE).

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
---584337861-975467389-1184309895=:15603--
