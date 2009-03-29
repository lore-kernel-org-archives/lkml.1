Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZC2Oqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZC2Oqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbZC2Oq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:46:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45710 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbZC2Oq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:46:28 -0400
Date: Sun, 29 Mar 2009 16:45:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090329144531.GA1408@ucw.cz>
References: <cklHL-5IW-23@gated-at.bofh.it> <ckm0Q-6o4-3@gated-at.bofh.it> <ckmaG-6AC-5@gated-at.bofh.it> <ckmWO-7Ro-5@gated-at.bofh.it> <ckn6L-84h-19@gated-at.bofh.it> <cknzG-ff-7@gated-at.bofh.it> <cknJk-IB-9@gated-at.bofh.it> <ckoFm-2eg-3@gated-at.bofh.it> <ckoYP-2DC-13@gated-at.bofh.it> <E1LnX6V-0001aA-AU@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LnX6V-0001aA-AU@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-03-28 12:53:34, Bodo Eggert wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Fri, 27 Mar 2009, Linus Torvalds wrote:
> 
> >> Yes, some editors (vi, emacs) do it, but even there it's configurable.
> > 
> > .. and looking at history, it's even pretty modern. From the vim logs:
> > 
> > Patch 6.2.499
> > Problem:   When writing a file and halting the system, the file might be lost
> > when using a journalling file system.
> > Solution:  Use fsync() to flush the file data to disk after writing a file.
> > (Radim Kolar)
> > Files:     src/fileio.c
> > 
> > so it looks (assuming those patch numbers mean what they would seem to
> > mean) that 'fsync()' in vim is from after 6.2 was released. Some time in
> > 2004.
> 
> Besides that, it's a fix specific for /journaled/ filesystems. It's easy to see
> that the same journal that was supposed to increase filesystem reliability
> is CAUSING more unreliable behavior.

Journaling is _not_ supposed to increase filesystem reliability.

It improves fsck time. That's it.

Actually ext2 is more reliable in ext3 --  fsck tells you
about errors on parts of disk that are not normallly used.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
