Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYKUN5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYKUN5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYKUN5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:57:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33983 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753779AbYKUN53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:57:29 -0500
Date: Thu, 20 Nov 2008 14:09:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: mtk.manpages@gmail.com, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081120130902.GA1408@ucw.cz>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com> <20081117175212.GA2224@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117175212.GA2224@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-17 20:52:12, Evgeniy Polyakov wrote:
> On Mon, Nov 17, 2008 at 12:23:01PM -0500, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
> > > Cookie was created to store information used to somehow connect events to
> > > each other. PID does that from another angle than rename.
> > 
> > Yes, but it does it in an inconsistent, incomplete way.
> 
> It was not my decision, I can not argue if it could be good, bad, perfect
> or shine. It is what we have, and I'm trying to extend it not breaking
> other things up.
> 
> > > Extending
> > > (rewriting userspace event processing part) events is a solution for the
> > > new project,
> > 
> > Not quite sure of your point here.  Whatever change is made, userspace
> > apps will need to be trained to understand the interface.
> 
> I mean kernel event generation side will have to be rewritten: new
> event structures, new members, new field usage scenario and so on.
> 
> > > while existing patch (where all security concerns are
> > > resolved) is a minimum functionality extension.
> > 
> > It is a minimum functionality extension that serves the needs of one
> > or a few projects, while dirtying the design for all users.
> 
> Yes, this is a minimum functionality extension, which breaks nothing.
> That's why it is a good idea, but I agree that there may be better than
> just a good idea and implementation :)

Breaks nothing?!

Introducing ugly hack with broken permission check we have to maintain
forever seems like way too much breakage for 14 lines.

> And I actually answered, that this may be a good idea for the new
> project. Although if things work right now no one will ever try to
> change it. It does not work in my case, so I need to invent as simple
> as possible way to fix it.

'as simple diff as possible' is pretty bad criterium for kernel
merges.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
