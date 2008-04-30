Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbYD3U5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbYD3U5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765392AbYD3U5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:57:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46395 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764925AbYD3U5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:57:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Wed, 30 Apr 2008 22:56:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <alpine.LFD.1.10.0804301307460.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301307460.2980@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302256.19986.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of April 2008, Linus Torvalds wrote:
> 
> On Wed, 30 Apr 2008, Linus Torvalds wrote:
> > 
> > In fact, I'd personally like to make it even shorter
> 
> Just to clarify: I'd actually like to make the merge window be just a 
> week. If even that.
> 
> With linux-next hopefully stepping up to be a place where the actual 
> _conflicts_ (which are usually not the big problem, they are just 
> inconvenient from a timing standpoint) can get found and handled early, a 
> shorter merge window should be technically possible.

That even might be better, if there's less code merged as a result.

> HOWEVER. Even now, at two weeks, we do have issues where timing just 
> doesn't fit some developer, because of conferences or vacations or just 
> random personal issues or whatever. There are always people who grumble 
> because the window didn't work for them.

Well, where's it stated that you have to develop new code for each merge
window?  By making shorter merge windows with less code merged in each of
them, we could actaully improve things.

> Of course, they should have had it all ready, but somehow that simply 
> doesn't happen. I think it's against most human nature to be quite _that_ 
> forward-looking.
> 
> And maybe everything would be ok if we could also shorten the actual 
> release cycle, so that if you miss one merge window for some random 
> conference or other (or just a *really* bad hair-day and you didn't get 
> your act together), you wouldn't mind too much and you'd just hit the next 
> one instead.

Exactly.

> But that, in turn, is unrealistic because when bugs do happen, the latency 
> you get between testers and developers is long enough that I really don't 
> think we can shorten the after-merge-window thing much. Six weeks seems to 
> be already pushing it.

That depends on the amount of bugs introduced during the merge window.  With
shorter merge windows we may introduce fewer bugs per merge window and
the most subtle ones take more six weeks to find anyway.

> And as mentioned, a longer after-merge-window-stabilization phase is just 
> going to aggravate the problem next time around.
> 
> We could have staggered releases, but let's face it, that's what -mm and 
> linux-next and stable is all about.

Well, that's assuming that people test linux-next and -mm etc., but frankly I'm
not seeing that happening.  Hopefully, things are going to improve.

Thanks,
Rafael
