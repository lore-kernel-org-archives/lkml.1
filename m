Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZC2TQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZC2TQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZC2TQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:16:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37297 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZC2TQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:16:00 -0400
Date: Sun, 29 Mar 2009 21:15:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bodo Eggert <7eggert@gmx.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090329191551.GA1406@ucw.cz>
References: <ckmaG-6AC-5@gated-at.bofh.it> <ckmWO-7Ro-5@gated-at.bofh.it> <ckn6L-84h-19@gated-at.bofh.it> <cknzG-ff-7@gated-at.bofh.it> <cknJk-IB-9@gated-at.bofh.it> <ckoFm-2eg-3@gated-at.bofh.it> <ckoYP-2DC-13@gated-at.bofh.it> <E1LnX6V-0001aA-AU@be1.7eggert.dyndns.org> <20090329144531.GA1408@ucw.cz> <alpine.LFD.2.00.0903290830230.3994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903290830230.3994@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Actually ext2 is more reliable in ext3 --  fsck tells you
> > about errors on parts of disk that are not normallly used.
> 
> No. ext2 is not more reliable than ext3.
> 
> ext2 gets way more errors (that whole 5s + 30s thing), and has no 
> "data=ordered" mode to even ask for more reliable behavior.
> 
> And even if compared to "data=writeback" (which approximates the ext2 
> writeout ordering), and assuming that the errors are comparable, at least 
> ext3 ends up automatically fixing up a lot of the errors that cause 
> inabilities to boot etc.
> 
> So don't be silly. ext3 is way more reliable than ext2. In fact, ext3 with 
> "data=ordered" is rather hard to screw up (but not impossible), and
> the 

Well, ext3 is pretty good, and if you have reliable hardware&kernel,
so all your unclean reboots are due to powerfails, it is better.

If you have flakey ide cable, bad disk driver, non-intel flash storage
 or memory with bit flips, you are better with ext2 -- it catches
 problems faster. Periodic disk check makes ext3 pretty good,
 unfortunately at least one distro silently disables.  Pavel

--
 (english) http://www.livejournal.com/~pavelmachek (cesky, pictures)
 http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
