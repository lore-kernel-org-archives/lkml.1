Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYHYMUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYHYMUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYHYMUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:20:39 -0400
Received: from 1wt.eu ([62.212.114.60]:2582 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbYHYMUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:20:38 -0400
Date: Mon, 25 Aug 2008 14:20:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Frey <cdfrey@foursquare.net>
Cc: Joe Peterson <joe@skyrush.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Visible Ctrl-C in latest kernels
Message-ID: <20080825122024.GA19337@1wt.eu>
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com> <20080824010231.GA26030@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824010231.GA26030@foursquare.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 09:02:32PM -0400, Chris Frey wrote:
> On Sat, Aug 23, 2008 at 11:52:02AM -0600, Joe Peterson wrote:
> > Vegard Nossum wrote:
> > >> I've noticed that on my Debian stable system, I can now see Ctrl-C characters
> > >> when using an xterm.  I've checked the stty settings and nothing seems
> > >> different.
> > 
> > Vegard, thanks for forwarding this to me.
> > 
> > Chris, yes, what you are now seeing on the newer kernel is correct.
> 
> Thanks guys.  I was not aware of this change before asking.  The change
> makes sense.  I wasn't having any problems with it, just wondering where
> it came from.
> 
> Thanks for the enlightenment. :-)

I would not be surprized that it is what has caused delays for Ctrl-C
to take effect for some of us. As discussed in another thread on the
subject, the problem was relatively recent and not easy to reproduce.
Now we have a patch to try to revert if/when we finally get a reproducible
case.

Willy

