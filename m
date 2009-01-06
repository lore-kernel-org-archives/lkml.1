Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbZAFPXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbZAFPXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZAFPXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:23:40 -0500
Received: from THUNK.ORG ([69.25.196.29]:39911 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZAFPXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:23:39 -0500
Date: Tue, 6 Jan 2009 10:23:36 -0500
From: Theodore Tso <tytso@mit.edu>
To: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Duane Griffin <duaneg@dghda.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: document ext3 requirements
Message-ID: <20090106152336.GA13086@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	Duane Griffin <duaneg@dghda.com>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20090103123813.GA1512@ucw.cz> <495FD5D7.2040907@ribosome.natur.cuni.cz> <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com> <20090103222957.GG1666@elf.ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz> <20090106100810.GB6700@merlin.emma.line.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090106100810.GB6700@merlin.emma.line.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:08:10AM +0100, Matthias Andree wrote:
> On Sun, 04 Jan 2009, Martin MOKREJŠ wrote:
> > Hmm, so if my dual-boot machine does not shutdown correctly and I boot
> > accidentally in M$ Win where I use ext2 IFS driver and modify some
> > stuff on the ext3 drive, after a while reboot to linux and the journal
> > get re-played ... Mmm ...
> 
> If the ext2 IFS driver mounts an ext3 file system that needs journal
> replay, the IFS driver is broken (unless it can replay the journal, of
> course - I stopped using that driver long ago, being unhappy with it).

Indeed; that's why there is a INCOMPAT NEEDS_RECOVERY feature flag to
prevent compliant ext2 implementations from mounting an ext3
filesystem that needs recovery.  We've thought about most of these
issues, almost a decade ago...

							- Ted
