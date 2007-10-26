Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbXJZRwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbXJZRwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXJZRvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:51:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36245 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbXJZRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:51:54 -0400
Date: Fri, 26 Oct 2007 19:51:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, sylvain.meyer@worldonline.fr,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Intel FB pixel clock calculation fix
Message-ID: <20071026175143.GB1573@elf.ucw.cz>
References: <m3ir6il3wl.fsf@maximus.localdomain> <20070910225221.f0eaf22c.akpm@linux-foundation.org> <m3veah75u6.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3veah75u6.fsf@maximus.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-09-11 14:18:57, Krzysztof Halasa wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> >> Intel framebuffer mis-calculated pixel clocks.
> 
> > and... what are the consequences of this miscalculation?  I need to know
> > such things so that I can decide whether a change is needed in 2.6.23.  And
> > 2.6.22.
> 
> The pixel clock (and thus both H and V sync) will be slower than
> requested, so if you set the minimum allowed the display may not
> sync. In case of really old CRT display it could theoretically
> damage it.
> 
> I'm using it with PAL TV (using RGB input - SCART connector) and
> the bug prevented it from working at all (TV requirements are more
> strict and made the bug visible).
> 
> I think 2.6.22 would be overkill, .23 - not sure.

I don't think this is -stable kind of bug.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
