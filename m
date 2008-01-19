Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbYASOxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbYASOxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbYASOxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:53:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36381 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762087AbYASOxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:53:01 -0500
Date: Sat, 19 Jan 2008 15:53:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Theodore Tso <tytso@MIT.EDU>, Bryan Henderson <hbryan@us.ibm.com>,
       Ric Wheeler <ric@emc.com>, Al Boldi <a1426z@gawab.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Daniel Phillips <phillips@google.com>,
       Rik van Riel <riel@redhat.com>, Valerie Henson <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD]
	Incrementalfsck)
Message-ID: <20080119145317.GG24512@elf.ucw.cz>
References: <478FE22D.9030907@emc.com> <OF3F61F02C.985CCACC-ON882573D4.0001DCF2-882573D4.0002E9F5@us.ibm.com> <20080118142308.GD12796@mit.edu> <Pine.LNX.4.61.0801181006330.7389@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0801181006330.7389@chaos.analogic.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-18 10:16:30, linux-os (Dick Johnson) wrote:
> 
> On Fri, 18 Jan 2008, Theodore Tso wrote:
> 
> > On Thu, Jan 17, 2008 at 04:31:48PM -0800, Bryan Henderson wrote:
> >> But I heard some years ago from a disk drive engineer that that is a myth
> >> just like the rotational energy thing.  I added that to the discussion,
> >> but admitted that I haven't actually seen a disk drive write a partial
> >> sector.
> >
> > Well, it would be impossible or at least very hard to see that in
> > practice, right?  My understanding is that drives do sector-level
> > checksums, so if there was a partially written sector, the checksum
> > would be bogus and the drive would return an error when you tried to
> > read from it.
> >
> >> Ted brought up the separate issue of the host sending garbage to the disk
> >> device because its own power is failing at the same time, which makes the
> >> integrity at the disk level moot (or even undesirable, as you'd rather
> >> write a bad sector than a good one with the wrong data).
> >
> > Yep, exactly.  It would be interesting to see if this happens on
> > modern hardware; all of the evidence I've had for this is years old at
> > this point.
> 
> I have a Seagate Barracuda 7200.9 80 Gbyte SATA drive that I
> use for experiments. I can permanently destroy a EXT3 file-system
> at least 50% of the time by disconnecting the data cable while
> a `dd` write to a file is in progress. Something bad happens
> making partition information invalid. I have to re-partition
> to reuse the drive.

Does turning off writeback cache on disk help? This is quite serious,
I'd say...

								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
