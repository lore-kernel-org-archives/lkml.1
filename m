Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZIIIIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZIIIIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZIIIIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:08:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40776 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZIIIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:08:37 -0400
Date: Wed, 9 Sep 2009 10:08:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig CROSS_COMPILE option
Message-ID: <20090909080833.GA28586@elf.ucw.cz>
References: <20090905002947.A4C678BEB1@magilla.sf.frob.com> <20090907130402.GB1595@ucw.cz> <20090907183801.379228BF3F@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907183801.379228BF3F@magilla.sf.frob.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-07 11:38:01, Roland McGrath wrote:
> > Yes that would be very nice. Editing Makefile every time I
> > crosscomppile for arm sucks.
> 
> The other trick I can recommend is to write a GNUmakefile containing:
> 
> ARCH=foo
> CROSS_COMPILE=foo-linux-
> include Makefile

Hehe, thanks.

> (GNU make reads GNUmakefile in preference to Makefile.)
> But this manual hackery is still not nearly as nice as the automagic way.
> 
> > But... do we need an option for subarch, too? And will Kconfig system
> > handle that?
> 
> I'm not sure I follow exactly what your concern is.  I am mostly familiar
> with doing x86 and powerpc builds.  For both of those, the kernel config
> sets whether it's the 32-bit or 64-bit world.

Well, my concern is that your patch allows me to set $CROSS_COMPILE,
but I need to set $ARCH too, to get useful result. So I can't actually
see how to use your patch.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
