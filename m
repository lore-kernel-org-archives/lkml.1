Return-Path: <linux-kernel-owner+w=401wt.eu-S935770AbZDBLGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935770AbZDBLGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935676AbZDBLGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:06:00 -0400
Received: from tichy.grunau.be ([85.131.189.73]:53689 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935706AbZDBLF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:05:59 -0400
Date: Thu, 2 Apr 2009 13:05:32 +0200
From: Janne Grunau <j@jannau.net>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090402110532.GA5132@aniel>
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401210337.GB3797@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 05:03:38PM -0400, Lennart Sorensen wrote:
> On Thu, Mar 26, 2009 at 06:25:19PM -0700, Andrew Morton wrote:
> > The JBD journal is a massive designed-in contention point.  It's why
> > for several years I've been telling anyone who will listen that we need
> > a new fs.  Hopefully our response to all these problems will soon be
> > "did you try btrfs?".
> 
> Oh I look forward to the day when it will be safe to convert my mythtv
> box from ext3 to btrfs.

You could convert it to xfs now. xfs is probably the file system with
the lowest complaints usage ratio within the mythyv community.
Using distinct discs for system and recording storage helps too.

> Current kernels just have too much IO latency
> with ext3 it seems.

MythTV calls fsync every few seconds on ongoing recordings to prevent
stalls due to large cache writebacks on ext3.

cheers

Janne
(MythTV developer)
