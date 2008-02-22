Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYBVQDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYBVQDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYBVQC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:02:58 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3507 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbYBVQC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:02:57 -0500
Date: Fri, 22 Feb 2008 10:48:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Newall <davidn@davidnewall.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Adrian Bunk <bunk@kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Glenn Streiff <gstreiff@neteffect.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Faisal Latif <flatif@neteffect.com>
Subject: Re: [ofa-general] Re: Merging of completely unreviewed drivers
Message-ID: <20080222154843.GC3067@tuxdriver.com>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE2985.6020305@davidnewall.com> <e2e108260802220429l5857c3edj351246ee31dd2a3e@mail.gmail.com> <47BEDB3F.4090100@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BEDB3F.4090100@davidnewall.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:55:03AM +1030, David Newall wrote:
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

I'm sure all those assumptions are baked-in to the estimate.  Yet the
fact remains that people's eyes are only so good and most people will
be reading at similar distances from the screen.  So I don't see any
reason to invalidate those assumptions.  FWIW, I find reading longer
lines to be painful -- it is easier to loose one's place in the text.

I would also echo a point Jeff Garzik made elsewhere that it is often
beneficial to have multiple windows oppen side-by-side.  Longer lines
makes it harder to do that in a useful way.  Instead the lines either
wrap or just trail off the screen.  See the output of sdiff for how
this limits usefulness.

> >  My experience is that the readability of source
> > code decreases when the lines are very long (more than 160
> > characters).
> 
> The point is that the width, excluding leading and trailing white space,
> is what really matters.  Even deeply indented code can be a snap to
> understand if you don't have to fight artificial line breaks.  And we've
> got a much wider -- and taller! -- space available than we had in the
> old 80x24 (and 80x1) days.

I'm not sure deeply indented code is ever a snap to understand.
And FWIW, I'd rather deal with "artificial" line breaks than parameter
lists that just stream off the side of the page.  The line breaks
make long parameters lists easier to digest.  I'll sacrifice the
occasional odd breakage of a long string.

John
-- 
John W. Linville
linville@tuxdriver.com
