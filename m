Return-Path: <linux-kernel-owner+w=401wt.eu-S933182AbXGMG5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbXGMG5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935419AbXGMG4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:56:32 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43934 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935209AbXGMG4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:56:30 -0400
Date: Fri, 13 Jul 2007 08:56:24 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 2/4] fbdev: Add fb_append_extra_logo()
In-Reply-To: <1184285757.4566.11.camel@daplas>
Message-ID: <Pine.LNX.4.62.0707130855360.15603@pademelon.sonytel.be>
References: <20070710122702.765654000@pademelon.sonytel.be>
 <20070710123540.678435000@pademelon.sonytel.be> <1184285757.4566.11.camel@daplas>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1045557791-1184309784=:15603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1045557791-1184309784=:15603
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jul 2007, Antonino A. Daplas wrote:
> On Tue, 2007-07-10 at 14:27 +0200, Geert Uytterhoeven wrote:
> > --- a/drivers/video/fbmem.c
> > +++ b/drivers/video/fbmem.c
> > @@ -318,6 +318,13 @@ static struct logo_data {
> >  	const struct linux_logo *logo;
> >  } fb_logo __read_mostly;
> >  
> > +#define FB_LOGO_EX_NUM_MAX 10
> > +static struct logo_data_extra {
> > +	const struct linux_logo *logo;
> > +	unsigned int n;
> > +} fb_logo_ex[FB_LOGO_EX_NUM_MAX];
> > +static unsigned int fb_logo_ex_num;
> > +
> >  static void fb_rotate_logo_ud(const u8 *in, u8 *out, u32 width, u32 height)
> >  {
> >  	u32 size = width * height, i;
> > @@ -411,10 +418,22 @@ static void fb_do_show_logo(struct fb_in
> >  	}
> >  }
> >  
> > +#ifdef CONFIG_FB
> 
> The #ifdef is redundant.

IIRC, it's needed for the CONFIG_FB=m case.

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
---584337861-1045557791-1184309784=:15603--
