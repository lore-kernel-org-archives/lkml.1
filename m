Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbYECLHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbYECLHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 07:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYECLH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 07:07:28 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34848 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbYECLH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 07:07:28 -0400
Date: Sat, 3 May 2008 14:06:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Willy Tarreau <w@1wt.eu>, =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080503110631.GJ5838@cs181133002.pp.htv.fi>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org> <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org> <20080502213146.GD24080@logfs.org> <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org> <20080502215833.GG24080@logfs.org> <20080503070318.GR8474@1wt.eu> <20080503091111.GH5838@cs181133002.pp.htv.fi> <84144f020805030244y44313fdl17cee6fa38bfd690@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84144f020805030244y44313fdl17cee6fa38bfd690@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 12:44:12PM +0300, Pekka Enberg wrote:
> Hi Adrian,
> 
> On Sat, May 3, 2008 at 12:11 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > > Why not merge it and mark it experimental then ? In fact, this is about
> > > what you're looking for : reduced merge hassle and more testers.
> >
> >  Andi already answered that one:
> >
> > "Merging file systems too early can quickly ruin their name and that
> >   taint is hard to ever get rid again then (e.g. happened to JFS)"
> >
> >  And a stable kernel shouldn't be something for getting "more testers",
> >  it should be for tested code ready to be used in production.
> >  What you call "more testers" would be people who try it in production
> >  (e.g. to overcome shortcomings of JFFS2) thinking it was stable.
> >
> >  And no, EXPERIMENTAL in the kernel is not usable for keeping people from
> >  trying known-whacky code.
> 
> I think ext4 already set the precedent that you _can_ do development
> within the 2.6 series, no?

I'd call the ext4 case a mistake we shouldn't repeat.

It's available in the kernel since 2006.

I've seen people using ext4 on their computers running with a corrupted 
filesystem since fsck was at that point not yet capable of fixing 
whatever was corrupted.

At least one distribution already has ext4 enabled in their kernels.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

