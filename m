Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYECJMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYECJMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbYECJMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:12:09 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58840 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbYECJMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:12:07 -0400
Date: Sat, 3 May 2008 12:11:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080503091111.GH5838@cs181133002.pp.htv.fi>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org> <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org> <20080502213146.GD24080@logfs.org> <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org> <20080502215833.GG24080@logfs.org> <20080503070318.GR8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080503070318.GR8474@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 09:03:18AM +0200, Willy Tarreau wrote:
> On Fri, May 02, 2008 at 11:58:33PM +0200, Jörn Engel wrote:
> > On Fri, 2 May 2008 14:39:23 -0700, Linus Torvalds wrote:
> > > 
> > > Quite frankly, if that's the case, I'd *much* rather see that worked on 
> > > first, so that there aren't any format changes that are already known to 
> > > be pending before it even gets merged.
> > > 
> > > Would it be at all possible to try to do that, or is it just "too far 
> > > out"?
> > 
> > Definitely possible.  The last similar change happened in December and
> > took until March until I ran out of stupid regressions from it.  Most
> > likely there are still some I just haven't found yet.
> > 
> > The question is when to draw the line and say "This is useful as-is for
> > a sufficient number of users."  I don't have a good answer to it.  I
> > certainly expect more changes in the future, including format changes.
> > And if we wait for them all to happen, it won't get merged this decade.
> 
> Why not merge it and mark it experimental then ? In fact, this is about
> what you're looking for : reduced merge hassle and more testers.

Andi already answered that one:
"Merging file systems too early can quickly ruin their name and that 
 taint is hard to ever get rid again then (e.g. happened to JFS)"


And a stable kernel shouldn't be something for getting "more testers", 
it should be for tested code ready to be used in production.
What you call "more testers" would be people who try it in production
(e.g. to overcome shortcomings of JFFS2) thinking it was stable.

And no, EXPERIMENTAL in the kernel is not usable for keeping people from 
trying known-whacky code.


> Willy


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

