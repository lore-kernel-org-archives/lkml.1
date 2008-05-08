Return-Path: <linux-kernel-owner+w=401wt.eu-S934224AbYEHW47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224AbYEHW47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762132AbYEHW4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:56:50 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:10807 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760396AbYEHW4t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:56:49 -0400
Date: Thu, 8 May 2008 23:56:45 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Adrian Bunk <bunk@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GIT bisection range errors
Message-ID: <20080508225645.GA24725@deepthought>
References: <48237CA0.4080001@keyaccess.nl> <20080508222545.GH22887@cs181133002.pp.htv.fi> <48238087.7000509@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48238087.7000509@keyaccess.nl>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 12:36:55AM +0200, Rene Herman wrote:
> On 09-05-08 00:25, Adrian Bunk wrote:
> >On Fri, May 09, 2008 at 12:20:16AM +0200, Rene Herman wrote:
> >>Good day.
> >>
> >>I'm in a git bisect and am experiencing strangeness. I did a
> >>
> >>$ git checkout -b rc v2.6.26-rc1
> >>$ git bisect start
> >>$ git bisect bad
> >>$ git bisect good v2.6.25
> >>
> >>Yet, during this I'm finding myself at 2.6.25-rc6 and 2.6.25-rc8
> >>as the last two results (both good...).
> >>
> >>Here's the BISECT_LOG upto this point. Is there anyone available
> >>who understands this well enough to be able to say from this that
> >>my tree is fubar? It should be a straight Linus' clone, and it's
> >>always pulling without trouble.
> >>
> >>git-bisect start
> >># bad: [2ddcca36c8bcfa251724fe342c8327451988be0d] Linux 2.6.26-rc1
> >>git-bisect bad 2ddcca36c8bcfa251724fe342c8327451988be0d
> >># good: [4b119e21d0c66c22e8ca03df05d9de623d0eb50f] Linux 2.6.25
> >>git-bisect good 4b119e21d0c66c22e8ca03df05d9de623d0eb50f
> >># bad: [7ae44cfa7ab29b277691327e8de790d7b880722f] [ALSA] snd-powermac: 
> >>style awacs.s and awacs.h
> >>git-bisect bad 7ae44cfa7ab29b277691327e8de790d7b880722f
> >># good: [7cea51be4e91edad05bd834f3235b45c57783f0d] security: fix up 
> >>documentation for security_module_enable
> >>git-bisect good 7cea51be4e91edad05bd834f3235b45c57783f0d
> >># bad: [8f19ca1341a6d89bd96e2e69e6e10f46d3258089] x86: unify gfp masks
> >>git-bisect bad 8f19ca1341a6d89bd96e2e69e6e10f46d3258089
> >># good: [f49e1aa133c2c9b74b5dfddca8863609bbda9086] [NETFILTER]: 
> >>nf_conntrack_sip: update copyright
> >>git-bisect good f49e1aa133c2c9b74b5dfddca8863609bbda9086
> >># good: [0b18542b7f5379e052d2a3132be91185776e7ceb] [NET]: Sink IPv6 
> >>menuoptions into its own submenu
> >>git-bisect good 0b18542b7f5379e052d2a3132be91185776e7ceb
> >
> >Don't trust any dates you see in git.  ;-)
> >
> >The last commit in your list was added to David's tree at around the 
> >time Linus released Linux 2.6.25-rc7.
> >
> >But David's tree was merged into Linus' tree after 2.6.25.
> >
> >So actually everything is fine.
> 
> Well, thanks for the reply and I'm going forward for now, but the Makefile
> is actually calling this 2.6.25-rc8. My next "git bisect good" after the
> above landed me now after 2.6.25 according to the Makefile. It could just
> be a tags issue I guess, where my tree is confused about what tag belongs
> to v2.6.25?
> 
> (new two lines in the log)
> 
> # good: [ba380013b681e91e059f95b51002f8d43024b371] b43: Add fastpath to 
> b43_mac_suspend()
> git-bisect good ba380013b681e91e059f95b51002f8d43024b371
> 
> Rene.
 I reported a similar thing at the beginning of April
http://lkml.org/lkml/2008/4/2/390 - 2.6.25-rc1 bad, 2.6.24 good, git
dropped me back at 2.6.24-rc4 (again, according to the top level
Makefile).

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
