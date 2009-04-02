Return-Path: <linux-kernel-owner+w=401wt.eu-S1764837AbZDBX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764837AbZDBX1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbZDBX1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:27:23 -0400
Received: from thunk.org ([69.25.196.29]:38685 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZDBX1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:27:23 -0400
Date: Thu, 2 Apr 2009 19:27:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090402232715.GE9870@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402121735.GD10642@mit.edu> <20090402215442.GC3795@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402215442.GC3795@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 05:54:42PM -0400, Lennart Sorensen wrote:
> On Thu, Apr 02, 2009 at 08:17:35AM -0400, Theodore Tso wrote:
> > Well, ext4 will be an interim solution you can convert to first.  It
> > will be best with a backup/reformat/restore pass, better if you enable
> > extents (at least for new files, but then you won't be able to go back
> > to ext3), but you'll get improvements even if you just mount an ext3
> > filesystem as ext4.
> 
> Well I did pickup a 1TB external USB/eSATA drive for pretty much such
> a task.  I wasn't sure if ext4 was ready or stable enough to play
> with yet though.

To play with, definitely.  For production use, I'll have to let you
make your own judgements.  I've been using it on my laptop since July.

At the moment, there's only one bug which I'm very concerned about,
being worked here:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/330824

But a number of community distro's will be supporting it within the
next month or two.  So it's definitely getting there.  As we increase
the user base, we'll turn up more of the harder-to-reproduce bugs, but
hopefully we'll get them fixed quickly.

					- Ted
