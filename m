Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbXJYFTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbXJYFTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXJYFTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:19:07 -0400
Received: from ozlabs.org ([203.10.76.45]:55300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXJYFTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:19:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] lguest: paravirt boot code
Date: Thu, 25 Oct 2007 15:19:05 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
References: <200710221237.14542.rusty@rustcorp.com.au> <200710231603.21620.rusty@rustcorp.com.au> <alpine.LFD.0.999.0710230903330.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710230903330.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251519.05641.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 02:10:21 Linus Torvalds wrote:
> On Tue, 23 Oct 2007, Rusty Russell wrote:
> > Well, with that out the way, and some scatterlist fixups, please pull
> > from
> >
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest.git
>
> Ok. However, please include a proper diffstat. And by proper, I mean:
>
> 	git diff -M --stat --summary

Thanks, that is much better.  I was just happy to locate git diff in the 133 
git commands on my system; finding options 4, 8 and 22 was beyond my skill.

So, this time for sure!  I haven't figured out how everyone does those neat 
committer: commits* lists, but I'm sure there's an option here somewhere...

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest.git

 Rusty Russell - lguest: documentation update
 Rusty Russell - lguest: Add to maintainers file.
 Jeff Garzik - lguest: build fix
 Rusty Russell - lguest: clean up lguest_launcher.h
 Rusty Russell - lguest: remove unused "wake" element from struct lguest
 Rusty Russell - lguest: use defines from x86 headers instead of magic numbers
 Rusty Russell - lguest: example launcher header cleanup.

Without the documentation update (which only changes comments and whitespace), 
the diff looks like this:

 Documentation/lguest/lguest.c   |   23 +++++++++++------------
 MAINTAINERS                     |    7 +++++++
 arch/x86/lguest/boot.c          |    6 +++---
 drivers/lguest/lg.h             |    3 ---
 drivers/lguest/x86/core.c       |    2 +-
 include/linux/lguest_launcher.h |   18 ++++--------------
 6 files changed, 26 insertions(+), 33 deletions(-)

Including the documentation update, it looks scarier:

 Documentation/lguest/lguest.c         |  178 +++++++++++++++++++-------------
 MAINTAINERS                           |    7 ++
 arch/x86/lguest/boot.c                |   54 +++++-----
 arch/x86/lguest/i386_head.S           |    8 +-
 drivers/lguest/core.c                 |    5 +-
 drivers/lguest/hypercalls.c           |   11 +-
 drivers/lguest/interrupts_and_traps.c |   37 ++++++--
 drivers/lguest/lg.h                   |    7 +-
 drivers/lguest/lguest_device.c        |   11 ++-
 drivers/lguest/lguest_user.c          |   23 ++--
 drivers/lguest/page_tables.c          |  113 +++++++++++++--------
 drivers/lguest/segments.c             |   48 ++++++----
 drivers/lguest/x86/core.c             |  122 ++++++++++++-----------
 drivers/lguest/x86/switcher_32.S      |   71 ++++++++++----
 include/asm-x86/lguest_hcall.h        |   16 ++--
 include/linux/lguest.h                |    4 +-
 include/linux/lguest_launcher.h       |   24 ++---
 17 files changed, 440 insertions(+), 299 deletions(-)

Cheers,
Rusty.
