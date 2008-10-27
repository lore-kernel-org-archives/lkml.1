Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYJ0UnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYJ0UnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYJ0UnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:43:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57999 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751947AbYJ0UnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:43:10 -0400
Date: Mon, 27 Oct 2008 21:42:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rodriguez@atheros.com
Subject: Re: [PATCH] wireless: fix regression caused by regulatory config
	option
Message-ID: <20081027204249.GA1620@ucw.cz>
References: <20081026103024.2712ddc9@infradead.org> <20081026200939.GC12648@tuxdriver.com> <20081026131818.7517c103@infradead.org> <1225052537.3746.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225052537.3746.5.camel@johannes.berg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-10-26 21:22:16, Johannes Berg wrote:
> On Sun, 2008-10-26 at 13:18 -0700, Arjan van de Ven wrote:
> 
> > > Is it common practice to have compatibility options default to
> > > "y"?  I'm not saying it shouldn't be, just wondering if it has been
> > > traditionally?
> > 
> > yes
> > 
> > default should be "keep working as before"
> > 
> > it's not always nice, especially if you're trying to get rid of some
> > nasty stuff, but think of it this way: you should be able to use a
> > new kernel on an existing distro, at least for a reasonable type of
> > distro (eg something shipped in, say, the last 2 years). In this case:
> > even Fedora 10 is not likely to work!
> 
> Well, actually, it _ought_ to work fine, with a smaller set of channels,

Really? It will still break if your AP uses one of those channels, right?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
