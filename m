Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZAFKIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZAFKIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZAFKIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:08:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:54487 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754562AbZAFKIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:08:14 -0500
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX1/yHDZW2yvynMhIvURPwYmMVQ3xqHLTVXw+vXQ9n5
	+uiOmBSIJ0yHQT
Date: Tue, 6 Jan 2009 11:08:10 +0100
From: Matthias Andree <matthias.andree@gmx.de>
To: Martin =?iso-8859-15?Q?MOKREJ=A6?= 
	<mmokrejs@ribosome.natur.cuni.cz>
Cc: Duane Griffin <duaneg@dghda.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: document ext3 requirements
Message-ID: <20090106100810.GB6700@merlin.emma.line.org>
Mail-Followup-To: Martin =?iso-8859-15?Q?MOKREJ=A6?= <mmokrejs@ribosome.natur.cuni.cz>,
	Duane Griffin <duaneg@dghda.com>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20090103123813.GA1512@ucw.cz> <495FD5D7.2040907@ribosome.natur.cuni.cz> <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com> <20090103222957.GG1666@elf.ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <495FEE66.9080903@ribosome.natur.cuni.cz>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Jan 2009, Martin MOKREJ¦ wrote:

> Pavel Machek wrote:
> > On Sat 2009-01-03 22:17:15, Duane Griffin wrote:
> >> [Fixed top-posting]
> >>
> >> 2009/1/3 Martin MOKREJ¦ <mmokrejs@ribosome.natur.cuni.cz>:
> >>> Pavel Machek wrote:
> >>>> readonly mount does actually write to the media in some cases. Document that.
> >>>>
> >>> Can one avoid replay of the journal then if it would be unclean?
> >>> Just curious.
> >> Nope. If the underlying block device is read-only then mounting the
> >> filesystem will fail. I tried to fix this some time ago, and have a
> >> set of patches that almost always work, but "almost always" isn't good
> >> enough. Unfortunately I never managed to figure out a way to finish it
> >> off without disgusting hacks or major surgery.
> > 
> > Uhuh, can you just ignore the journal and mount it anyway?
> > ...basically treating it like an ext2?
> > 
> > ...ok, that will present "old" version of the filesystem to the
> > user... violating fsync() semantics.
> 
> Hmm, so if my dual-boot machine does not shutdown correctly and I boot
> accidentally in M$ Win where I use ext2 IFS driver and modify some
> stuff on the ext3 drive, after a while reboot to linux and the journal
> get re-played ... Mmm ...

If the ext2 IFS driver mounts an ext3 file system that needs journal
replay, the IFS driver is broken (unless it can replay the journal, of
course - I stopped using that driver long ago, being unhappy with it).

-- 
Matthias Andree
