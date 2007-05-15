Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbXEOO3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbXEOO3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 10:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXEOO3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 10:29:08 -0400
Received: from thunk.org ([69.25.196.29]:57237 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698AbXEOO3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 10:29:07 -0400
Date: Tue, 15 May 2007 10:28:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Blunck <jblunck@suse.de>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 13/14] ext3 whiteout support
Message-ID: <20070515142830.GA5656@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Blunck <jblunck@suse.de>,
	Bharata B Rao <bharata@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Blunck <j.blunck@tu-harburg.de>
References: <20070514093722.GB4139@in.ibm.com> <20070514094450.GO4139@in.ibm.com> <20070514201706.GD5286@schatzie.adilger.int> <4de7f8a60705141335m7214e8e9k9f96244738dd2b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4de7f8a60705141335m7214e8e9k9f96244738dd2b4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 10:35:47PM +0200, Jan Blunck wrote:
> 
> I don't know. I tried to contact him a few weeks ago but failed.
> Guess, maybe he isn't reading the @thunk.org email anymore which was
> reference in the e2fsprogs source I used.

I do pay more attention to mail sent to the @mit.edu address, but I
don't recall any reservation requests sent to my @thunk.org address
(nope, don't see it; maybe it got caught in my spam filters?  When did
you send it, precisely?)

> Ted,
> from ext2_fs.h I learn that the value 0x0020 is left unused.
> 
> #define EXT2_FEATURE_INCOMPAT_META_BG           0x0010
> #define EXT3_FEATURE_INCOMPAT_EXTENTS           0x0040
> #define EXT4_FEATURE_INCOMPAT_64BIT             0x0080
> 
> Is this intentionally?

I think 0x0020 was used at one point, but I can't remember what it was
used for.  It's almost certainly not in wide use at this point, so
it's probably safe to use it; OTOH it's not like we're running out of
bits at this point.

						- Ted

