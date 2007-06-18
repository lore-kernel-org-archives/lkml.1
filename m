Return-Path: <linux-kernel-owner+w=401wt.eu-S1763766AbXFROCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763766AbXFROCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762728AbXFROCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:02:39 -0400
Received: from thunk.org ([69.25.196.29]:42644 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762557AbXFROCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:02:37 -0400
Date: Mon, 18 Jun 2007 10:01:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       alan <alan@clueserver.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618140143.GD30244@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	alan <alan@clueserver.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618094524.GF5181@schatzie.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 03:45:24AM -0600, Andreas Dilger wrote:
> Too bad everyone is spending time on 10 similar-but-slightly-different
> filesystems.  This will likely end up with a bunch of filesystems that
> implement some easy subset of features, but will not get polished for
> users or have a full set of features implemented (e.g. ACL, quota, fsck,
> etc).  While I don't think there is a single answer to every question,
> it does seem that the number of filesystem projects has climbed lately.

I view some of the attempts for "from scratch" filesystems as ways of
testing out various designs as "proof-of-concepts".  It's a great way
of demo'ing ones ideas, to see how well they work.  There is a huge
chasm between a proof-of-concept and a full production filesystem that
has great repair/recovery tools, etc.  That's why it's so important to
do the POC implementation first, so folks can see how well it works
before investing a huge amount of effort to make it be
production-ready.

So I actually think the number of these new filesystem proposals are
*good* things.  It means people are interested in creating new
filesystems, and that's all good.  Eventually, we'll need to decide
which design ideas should be combined, and that may be a little tough
to the egos involved, but that's all part of the darwinian kernel
programming model.  Not all implementations make it into the kernel
mainline.  That doesn't mean that the work that was done on the
various schedular proposals were useless; they just helped demonstrate
concepts and advanced the debate.

Regards,

					- Ted
