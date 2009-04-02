Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZDBMSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZDBMSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZDBMRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:17:49 -0400
Received: from THUNK.ORG ([69.25.196.29]:34527 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbZDBMRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:17:48 -0400
Date: Thu, 2 Apr 2009 08:17:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090402121735.GD10642@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401210337.GB3797@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
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
> box from ext3 to btrfs.  Current kernels just have too much IO latency
> with ext3 it seems.  Older kernels were more responsive, but probably
> had other places they were less efficient.

Well, ext4 will be an interim solution you can convert to first.  It
will be best with a backup/reformat/restore pass, better if you enable
extents (at least for new files, but then you won't be able to go back
to ext3), but you'll get improvements even if you just mount an ext3
filesystem as ext4.

						- Ted
