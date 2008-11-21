Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYKUO5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYKUO5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbYKUO5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:57:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60767 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753634AbYKUO5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:57:24 -0500
Date: Fri, 21 Nov 2008 15:57:09 +0100
From: Pavel Machek <pavel@suse.cz>
To: Robert Love <rlove@rlove.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, mtk.manpages@gmail.com,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081121145709.GC1554@ucw.cz>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com> <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz> <20081121140325.GA12384@ioremap.net> <acdcfe7e0811210630s65404ef5pf2b94731c2a872e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdcfe7e0811210630s65404ef5pf2b94731c2a872e1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-11-21 09:30:38, Robert Love wrote:
> On Fri, Nov 21, 2008 at 9:03 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> 
> > Critics without suggestions is useless. What did you try to say here?
> > You you believe it should be done in a different way, please tell us how
> > you see this should be implemented.
> 
> Pavel has the bedside manner of a T-Rex, but he is right.

Heh. Will attach T-Rex to next email.

> Your solution needs to be (a) generally applicable and useful, with an
> (b) elegant and clean API, which (c) does not break ABI or API.
> 
> Overloading the cookie field is not the way to go. Finding ways to
> extend the API through inotify_init might be--you will have even
> higher hurdles of "do we really need this" though.
> 
> John & I intentionally did not add the pid field when writing inotify
> for reasons of security and questionable need. It also stinks to have
> to add a pid field to the event structure if that field is seldom
> used.

...plus the permission check was quite strange. We don't normally try
to hide PIDs, and 'equal uid' is very non-standard test. can_ptrace()
is normally used for such stuff...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
