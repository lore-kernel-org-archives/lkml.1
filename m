Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZBARIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZBARIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZBARIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:08:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59311 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZBARIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:08:43 -0500
Date: Sun, 1 Feb 2009 17:06:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090201170647.GA21913@n2100.arm.linux.org.uk>
References: <1233385816.17794.16.camel@localhost.localdomain> <20090131164410.GA11189@elte.hu> <1233469811.5846.14.camel@localhost.localdomain> <20090201103936.GA30157@elte.hu> <20090201164915.GA29264@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090201164915.GA29264@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01, 2009 at 05:49:15PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > These patches fixes 41 headers_check warnings as shown in first email.
> > 
> > Pulled into tip/core/header-fixes, thanks Jaswinder!
> 
> These are the remaining ones on x86:
> 
>      17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
>      12 /dev/shm/tip/usr/include/linux/soundcard.h
>       6 /dev/shm/tip/usr/include/asm/setup.h
>       3 /dev/shm/tip/usr/include/linux/nubus.h
>       2 /dev/shm/tip/usr/include/linux/in6.h
>       1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
>       1 /dev/shm/tip/usr/include/linux/socket.h
>       1 /dev/shm/tip/usr/include/linux/coda_psdev.h
>       1 /dev/shm/tip/usr/include/asm/prctl.h
> 
> They are all of the "extern's make no sense in userspace" type. What was the 
> verdict, are they worth touching, or should we turn off this warning in 
> 'make headers_check'?

So, what's this all about?

You know, if there's something that is relevant to others and you want to
_add_ them to the CC, at least leave enough of the original message so the
new people who are being CC'd have some clue what the hell the thread is 
about, and more importantly where to get the patches being discussed.

Until then, if this includes any ARM bits, NAK, because I don't know
what those changes are.
