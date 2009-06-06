Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZFFNfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZFFNfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 09:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZFFNfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 09:35:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:45485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbZFFNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 09:35:09 -0400
Subject: Re: [GIT PULL] headers_check fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20090606130210.GA9343@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244292857.2473.4.camel@ht.satnam>
	 <20090606130210.GA9343@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 19:04:37 +0530
Message-Id: <1244295277.2473.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 14:02 +0100, Russell King wrote:
> On Sat, Jun 06, 2009 at 06:24:17PM +0530, Jaswinder Singh Rajput wrote:
> > Linus,
> > 
> > Please pull headers_check fixes:
> > 
> > The following changes since commit 064e38aaded5269e573ac1c765284fd65c8ebd13:
> >   Linus Torvalds (1):
> >         Merge git://git.kernel.org/.../mason/btrfs-unstable
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master
> > 
> > Jaswinder Singh Rajput (6):
> >       headers_check fix: arm, hwcap.h
> 
> So inspite of NAKing this patch you send it anyway.
> 

Earlier it was already like this, because of Catalin Marinas
fault (commit f884b1cf578e0) and your ignorance you converted :

 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__

to :

 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)

I am just trying to rectify your mistake that __KERNEL__ should not be
used with other defines to easily export headers to userspace. Whole
kernel header files are following this protocol. Sam, Arnd and me are
trying to convince you. Why you need an exception ?

Thanks,
--
JSR



