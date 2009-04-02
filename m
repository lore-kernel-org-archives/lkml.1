Return-Path: <linux-kernel-owner+w=401wt.eu-S1763183AbZDBVu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763183AbZDBVu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZDBVuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:50:17 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:41160 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbZDBVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:50:16 -0400
Date: Thu, 2 Apr 2009 17:50:14 -0400
To: Janne Grunau <j@jannau.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090402215014.GB3795@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402110532.GA5132@aniel>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 01:05:32PM +0200, Janne Grunau wrote:
> You could convert it to xfs now. xfs is probably the file system with
> the lowest complaints usage ratio within the mythyv community.
> Using distinct discs for system and recording storage helps too.

Yeah, but I am not ready to give xfs another change yet.  The nasty bugs
back in 2.6.8ish days still hurt.  Locking up the filesystem when doing
rm -rf gcc-4.0 and having to repair it after a reboot was not fun.

> MythTV calls fsync every few seconds on ongoing recordings to prevent
> stalls due to large cache writebacks on ext3.

Yeah.  What I have been seeing since 2.6.24 or 2.6.25 or so is that it
sometimes simply doesn't start playback on a file, and after 15 seconds
or so times out, and then you ask it to try again and it works the next
time just fine.  Then at times it will stop responding to the keyboard or
remote in mythtv for up to 2 minutes, and then suddenly it will respond
to whatever you hit 2 minutes ago.  Fortunately that doesn't seem to
happen that often.  I was hoping to see if 2.6.28 helped that, but lirc
didn't seem to work on my remote with that version, so I went back to
2.6.26 again.  I haven't tried 2.6.29 on it yet since I am currently
trying to fix the debian nvidia-driver build against the new kbuild only
much too clever linux-headers-2.6.29 package they have come up with.
I think I have got that figured out though so I should be able to upgrade
that now.

-- 
Len Sorensen
