Return-Path: <linux-kernel-owner+w=401wt.eu-S1764292AbXFRPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764292AbXFRPh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762651AbXFRPht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:37:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50241 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762800AbXFRPhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:37:47 -0400
Date: Mon, 18 Jun 2007 11:32:38 -0400
From: Chris Mason <chris.mason@oracle.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       alan <alan@clueserver.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618153238.GG2061@think.oraclecorp.com>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618094524.GF5181@schatzie.adilger.int>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 03:45:24AM -0600, Andreas Dilger wrote:
> Too bad everyone is spending time on 10 similar-but-slightly-different
> filesystems.  This will likely end up with a bunch of filesystems that
> implement some easy subset of features, but will not get polished for
> users or have a full set of features implemented (e.g. ACL, quota, fsck,
> etc).  While I don't think there is a single answer to every question,
> it does seem that the number of filesystem projects has climbed lately.
> 
> Maybe there should be a BOF at OLS to merge these filesystem projects
> (btrfs, chunkfs, tilefs, logfs, etc) into a single project with multiple
> people working on getting it solid, scalable (parallel readers/writers on
> lots of CPUs), robust (checksums, failure localization), recoverable, etc.
> I thought Val's FS summits were designed to get developers to collaborate,
> but it seems everyone has gone back to their corners to work on their own
> filesystem?

Unfortunately, I can't do OLS this year, but anyone who wants to talk on
these things can drop me a line and we can setup phone calls or whatever
for planning.  Adding polish to any FS is not a one man show, and so I know
I'll need to get more people on board to really finish btrfs off.

One of my long term goals for btrfs is to figure out the features and
layout people are most interested in for filesystems that don't have to
be ext* backwards compatible.  I've got a pretty good start, but I'm
sure parts of it will change if I can get a big enough developer base.

> 
> Working on getting hooks into DM/MD so that the filesystem and RAID layers
> can move beyond "ignorance is bliss" when talking to each other would be
> great.  Not rebuilding empty parts of the fs, limit parity resync to parts
> of the fs that were in the previous transaction, use fs-supplied checksums
> to verify on-disk data is correct, use RAID geometry when doing allocations,
> etc.

Definitely.  There's a lot of work in the DM integration bits that are
not FS specific.

-chris

