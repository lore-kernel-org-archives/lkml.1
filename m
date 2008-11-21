Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYKUOhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYKUOhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYKUOhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:37:07 -0500
Received: from corega.com.ru ([195.178.208.66]:50679 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbYKUOhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:37:05 -0500
Date: Fri, 21 Nov 2008 17:37:02 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, John McCutchan <john@johnmccutchan.com>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081121143702.GA13931@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com> <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz> <20081121140325.GA12384@ioremap.net> <517f3f820811210620o34307610hf926bbe3b3828e8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517f3f820811210620o34307610hf926bbe3b3828e8c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael.

On Fri, Nov 21, 2008 at 09:20:39AM -0500, Michael Kerrisk (mtk.manpages@gmail.com) wrote:
> I think the point is this.  You want to introduce a change that
> address the needs of a single application.  Many others see the
> change, which though it may be simple and quick to implement, as "an
> ugly hack" -- it messes up an otherwise rather well designed API.
> Should we make such a change?  I think not -- and others are echoing
> that sentiment.  Your argument that "we should do this because no-one
> else has proposed a better way" is not sufficient rationale for
> uglifying this API to serve the needs of a single app -- the argument
> will not fly, no matter how many times you repeat it.  (Your statement
> "Critics without suggestions is useless" does not hold: one very
> useful purpose of critics is to maintain the status quo of "good
> taste" in API design.)

That's the point, I proposed an idea, people just say no, without
discussion on how this should be implemented. This is a sign that
people do not really know how they want this to be implemented, if
they care at all, but want to show that some cenversation took place.

It does not. There may be infinite ways to satisfy taste of the
beautiful for lots of people, I already tried, so know this perfectly
well. And when I ask how others expect it to look like, I got _zero_
responses except that to put it into different field, when you proposed
new inotify interface.

No one proposed netlink-like attributes nesting, no one proposed new
fields, nothing. Because no one really cares about that. Only becuase of
this fact I'm still trying to say that existing inotify works ok and its
ugly extension is not a bad idea. Because no one needs new inotify, new
fileds and new interfaces.

> At this stage, I see three possibilities -- you maintain an
> out-of-mainline patch for the kernel, and distribute that with your
> app; you work out some other *userspace* solution to your problem; or
> someone comes up with inotify-ng, designed to address your needs and
> those of others (okay, we may not know what those other needs are yet,
> but the question is if we could come up with an inotify-ng design that
> can extensible in a sane way).  I know that none of these options will
> be what you are happy with, but all of them have more life than your
> proposal, IMO.

I'm happy with any solution, which solves the problem. I proposed one.
It was not accepted. So I asked how this should look like? No response.
I proposed some ideas (pid, start/offset of the io) - still no response
if it is good, bad, ugly or beautiful.

But instead people want to throw a stone, that something is ugly.

-- 
	Evgeniy Polyakov
