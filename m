Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZAKKia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZAKKia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 05:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZAKKiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 05:38:21 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:45207 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZAKKiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 05:38:20 -0500
Date: Sun, 11 Jan 2009 11:38:13 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Lachlan McIlroy <lachlan@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.29
In-Reply-To: <Pine.LNX.4.64.0901021056360.14380@anakin>
Message-ID: <Pine.LNX.4.64.0901111137410.30201@anakin>
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
 <Pine.LNX.4.64.0901011048090.14380@anakin> <20090101170329.GA17892@infradead.org>
 <Pine.LNX.4.64.0901021056360.14380@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2009, Geert Uytterhoeven wrote:
> On Thu, 1 Jan 2009, Christoph Hellwig wrote:
> > On Thu, Jan 01, 2009 at 10:50:52AM +0100, Geert Uytterhoeven wrote:
> > > | fs/xfs/xfs_btree.c: In function 'xfs_btree_readahead_lblock':
> > > | fs/xfs/xfs_btree.c:736: warning: comparison is always true due to limited range of data type
> > > | fs/xfs/xfs_btree.c:741: warning: comparison is always true due to limited range of data type
> > > 
> > > left/right = xfs_fsblock_t (32 or 64 bit), NULLDFSBNO = xfs_dfsbno_t (64 bit)
> > 
> > Hmm, can't reproduce it here with CONFIG_LBD=n on x86, but the following
> 
> x86-32 or -64?
> 
> It may also depend on the compiler version. I have gcc version 4.1.2 20061115
> (prerelease) (Debian 4.1.1-21).
> 
> > patch should fix it:
> 
> Yep, the warning is good.
                      ^^^^
		      gone

JFYI, the bug has entered Linus' tree. The fix hasn't.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
