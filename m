Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYJMOnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYJMOnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYJMOnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:43:11 -0400
Received: from the.earth.li ([217.147.81.2]:58925 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbYJMOnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:43:10 -0400
Date: Mon, 13 Oct 2008 15:43:08 +0100
From: Jonathan McDowell <noodles@earth.li>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: X "Hangs" with RS690 + 2.6.26
Message-ID: <20081013144308.GF6418@earth.li>
References: <20080725094334.GC30002@earth.li> <alpine.DEB.0.82.0807251107400.30593@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0807251107400.30593@skynet.skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 11:10:07AM +0100, Dave Airlie wrote:
> > I've started to see "hangs" with X on an ATI RS690 with a 2.6.26 kernel.
> > The symptoms are that load average goes up, X stops accepting keypresses
> > or mouse clicks, but the cursor still moves around the screen in
> > response to the mouse being moved. I can't switch to a VT but can ssh in
> > remotely to see that things are still running. I don't seem to be able
> > to kill X but "shutdown -r now" cleanly reboots.
> > 
> > radeon driver is recent git - 1c5858484da4fb1c9bc3ac3b4d7a97863ab99730
> > but I've seen it with older revisions too.
> > 
> > It can take a couple of days for me to hit the problem, so a git bisect
> > could be a lengthy process. If anyone has any suggestions about faster
> > ways to track down the issue I'd like to hear them.
> 
> git log v2.6.25..v2.6.26 drivers/char/drm
... 
> not sure if you wanna try reverting some of those and seeing which is the 
> cause maybe..
 
I never figured out which of these caused the issues, but as a further
data point for anyone else suffering from the issue 2.6.27-rc kernels
appear to fix (or at least significantly ease) the problem; I managed a
23 day uptime on 2.6.27-rc5 with I think one X freeze during that period
that cleaned up after a Ctrl-Alt-Backspace. Not seen the same thing at
all on 2.6.27-rc7 (though only ran it for 14 days before rebooting into
2.6.27 proper).

J.

-- 
Web [        Can I trade this job for what's behind door 2?        ]
site: http:// [                                          ]       Made by
www.earth.li/~noodles/  [                      ]         HuggieTag 0.0.23
