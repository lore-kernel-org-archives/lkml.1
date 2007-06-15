Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbXFOIDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbXFOIDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXFOIDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:03:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44567 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbXFOIDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:03:14 -0400
Date: Fri, 15 Jun 2007 10:02:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Poole <mdpoole@troilus.org>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615080252.GA28281@elte.hu>
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706142049.41819.dhazelton@enter.net> <87fy4u0xty.fsf@graviton.dyn.troilus.org> <200706142246.57583.dhazelton@enter.net> <878xal2a0q.fsf@graviton.dyn.troilus.org> <alpine.LFD.0.98.0706142013120.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706142013120.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Michael Poole wrote:
> >
> > If the DRM signature and program executable are coupled such that 
> > they are not useful when separated, the implication to me is that 
> > they form one work that is based on the original Program.  This is 
> > beyond the GPL's permission for "mere aggregation".
> 
> So you want to make things like a 160-bit SHA1 hash of a binary be a 
> "derived work" of that software?
> 
> Trust me, you *really* don't want to go there. It's an insane legal 
> standpoint, and if you were right, we'd be in a *world* of trouble.
> 
> Think about something as simple as security software that creates 
> filesystem checksums for verifying the integrity of the filesystem, 
> and protects against tampering.
> 
> Do you *really* want to claim that the SHA1 checksum of your "oracle" 
> binary is owned by Oracle, and you need to have a special license to 
> copy that checksum around and verify it?

not only that, but it would instantly turn everyone who owns a hard 
drive or a CD-ROM into a copyright violator: the disks checksums the 
content of the disk _in a reversible way_. Same for RAID5 and RAID6 
techniques. By installing Quake3 on a Windows box one sure does not have 
permission to create a derived work of Windows and Quake3, right? =B-)

a checksum, a one-way hash, or even reversible parity bit(s) that 
'mixes' the copies of multiple works together clearly cannot be new work 
that falls under copyright protection.

Firstly, it is not a new work, because a 'work' has to be created by a 
human - and here the new content was created by a machine. Copyright 
protection only applies to sufficiently original works created by 
humans.

Secondly, it is _at most_ a new, partial copy of existing works and 
hence you need the permission to copy all the works in question. (but 
you needed that permission to create the harddisk anyway)

Thirdly, it could be argued that the sha1 is not even a copy, because it 
is irreversible and hence not even a single bit of the original work can 
be reconstructed from it hence it cannot even be a 'partial copy of the 
original'.

that's at least 3 robust levels of argument against the insane and 
absurd notion that the SHA1 key is somehow a derived work of the copy it 
checksums.

	Ingo
