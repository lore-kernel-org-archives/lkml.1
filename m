Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbXE1NDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbXE1NDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXE1NDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:03:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43319 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753610AbXE1NDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:03:23 -0400
Date: Mon, 28 May 2007 15:03:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>,
       Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
Message-ID: <20070528130318.GL18807@elf.ucw.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz> <20070518215731.GB10655@thunk.org> <20070520195526.GA5235@ucw.cz> <20070522180158.GA4668@thunk.org> <20070524173911.GA4541@ucw.cz> <20070528123824.GA32510@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528123824.GA32510@atrey.karlin.mff.cuni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > But here's what I've got:
> > 
> > oot@spitz:/home/pavel# fsck.ext2 -f /dev/hda3
> > e2fsck 1.38 (30-Jun-2005)
> > Pass 1: Checking inodes, blocks, and sizes
> > Inode 371989 has illegal block(s).  Clear<y>? yes
> > 
> > Illegal block #2 (134217728) in inode 371989.  CLEARED.
> > Pass 2: Checking directory structure
> > 
> > i_file_acl for inode 371988 (/home/root/misc/zaurus/smail) is 131072,
> > should be zero.
> > Clear<y>? yes
> > 
> > Pass 3: Checking directory connectivity
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information
> > Block bitmap differences:  -339972 +471044
> > Fix<y>? yes
> > 
> > Free blocks count wrong for group #10 (13882, counted=13883).
> > Fix<y>? yes
> > 
> > ...kernel 2.6.16-preempt (on zaurus). Filesystem should have been clean -- I was
> > using it till crash for half a year, but that's what journal is for,
> > right? ...But I guess this is almost impossible to debug?
>   Actually, your case doesn't seem to be hard. The first block number
> is 0x8000000 and the second one 0x20000. So something is flipping your
> bits...

Hmm, ouch. Yes, that machine was pretty unstable after repeated
suspend-to-RAMs, so I guess this is a symptom of same problem. Sorry
about noise.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
