Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbXEKMaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbXEKMaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbXEKM37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:29:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1380 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758658AbXEKM36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:29:58 -0400
Date: Wed, 9 May 2007 20:33:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070509203335.GA4290@ucw.cz>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz> <1178550653.11851.191.camel@pmac.infradead.org> <20070507194949.GB3981@ucw.cz> <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com> <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl> <1178646751.2824.48.camel@pmac.infradead.org> <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl> <1178721996.2824.199.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178721996.2824.199.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Considering Linux only -- does our text-mode VGA console driver make
> > any effort to print an arbitrary UTF-8-encoded text 
> > correctly?  What does it do when it runs beyond the limit of 512 
> > characters?  
> 
> I've no idea -- I haven't used the VGA text-mode console for years
> either. I rarely even sit in front of a box on which it even works --
> all the workstations I have these days are PowerPC, and use fbdev.

Even with fbdev... you are limited to 512 characters iirc. So.. who
has authority to say which subset of utf-8 is ok?

(Plus there is still lot of vga consoles out there -- all fedora users
afaict?)

> > And how about serial terminals?
> 
> It works fine over serial terminals. Why wouldn't it?

He probably means serial terminals... like physical vt100. I used to
have one (vt302 compatible or something).  Most emulators still
emulate vt100, and yes, vt100 predates utf-8.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
