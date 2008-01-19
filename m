Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbYASOvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbYASOvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYASOu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:50:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50248 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753473AbYASOu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:50:57 -0500
Date: Sat, 19 Jan 2008 15:51:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: Daniel Phillips <phillips@google.com>, David Chinner <dgc@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080119145111.GF24512@elf.ucw.cz>
References: <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz> <20080113174125.5f39ac64@lxorguk.ukuu.org.uk> <20080115201653.GA5639@elf.ucw.cz> <20080115214325.GN155407@sgi.com> <20080115230714.GC3573@elf.ucw.cz> <4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com> <20080116115144.GE22460@elf.ucw.cz> <16153.1200486036@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16153.1200486036@turing-police.cc.vt.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I guess I should try to measure it. (Linux already does writeback
> > caching, with 2GB of memory. I wonder how important disks's 2MB of
> > cache can be).
> 
> It serves essentially the same purpose as the 'async' option in /etc/exports
> (i.e. we declare it "done" when the other end of the wire says it's caught
> the data, not when it's actually committed), with similar latency wins.  Of
> course, it's impedance-matching for bursty traffic - the 2M doesn't do much
> at all if you're streaming data to it.  For what it's worth, the 80G Seagate
> drive in my laptop claims it has 8M, so it probably does 4 times as much
> good as 2M. ;)

I doubt "impedance-matching" is useful here. SATA link is fast/low
latency, and kernel already does buffering with main memory...

Hmm... what is the way to measure that? Tar decompress kernel few
times with cache on / cache off?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
