Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYBVPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYBVPSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 10:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbYBVPR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 10:17:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42810 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbYBVPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 10:17:56 -0500
Subject: Re: [ofa-general] Re: Merging of completely unreviewed drivers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Newall <davidn@davidnewall.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Adrian Bunk <bunk@kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Glenn Streiff <gstreiff@neteffect.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Faisal Latif <flatif@neteffect.com>
In-Reply-To: <47BEDB3F.4090100@davidnewall.com>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	 <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	 <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com>
	 <20080221210124.GD28328@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	 <m3tzk1q3rt.fsf@maximus.localdomain>	 <47BE2985.6020305@davidnewall.com>
	 <e2e108260802220429l5857c3edj351246ee31dd2a3e@mail.gmail.com>
	 <47BEDB3F.4090100@davidnewall.com>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 16:17:17 +0100
Message-Id: <1203693437.6242.40.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 00:55 +1030, David Newall wrote:
> Bart Van Assche wrote:
> > There is a reason to limit line length: scientific research has shown
> > that readability of regular texts is optimal for a line length between
> > 55 and 65 characters.
> 
> Putting aside the point that we're talking code, not regular text, I've
> heard that said before and I don't think it's quite like that.  Perhaps
> the numbers you said might assume various things such as the width of
> the eye's field of view, the distance to the image and the size of each
> character?

Not in my experience.

> >  My experience is that the readability of source
> > code decreases when the lines are very long (more than 160
> > characters).
> 
> The point is that the width, excluding leading and trailing white space,
> is what really matters.  Even deeply indented code can be a snap to
> understand if you don't have to fight artificial line breaks.  And we've
> got a much wider -- and taller! -- space available than we had in the
> old 80x24 (and 80x1) days.

I have 2 24" screens running at 1920x1200 with X forced to 75dpi and use
a 8pt Monospace font. (Yes, I can read that from more than 3ft away)

Using a fullscreen gvim (without the icons, but with the menu) with 3
vertical splits gives me 4 columns of 113 rows and 95 chars.

So, yes, I have the screen estate for very long lines, but I find that
long lines require more effort to read (that very much includes leading
whitespace). Also, since long lines are rare (and they should be, if you
nest too deep you have other issues) accommodating them would waste a
lot of screen estate otherwise useful for another column of text.

Even with e-mail, I can easily show over 200 characters wide with a
large font (say 11pt) but find it harder to read emails that don't
nicely wrap at 78. So much so that I often find myself not reading the
mail, or restyling it if I find it important enough to read anyway.

Please, lets keep the 80 as a guideline, and not trip over the
occasional lines that exceed it in good style (read: wrapping them would
indeed give uglier code)

