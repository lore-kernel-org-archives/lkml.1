Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZBASeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZBASeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 13:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZBASeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 13:34:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:49555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbZBASeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 13:34:22 -0500
Subject: Re: [git pull -tip] headers_check fixes for other architectures
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20090201164915.GA29264@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain>
	 <20090131164410.GA11189@elte.hu>
	 <1233469811.5846.14.camel@localhost.localdomain>
	 <20090201103936.GA30157@elte.hu>  <20090201164915.GA29264@elte.hu>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 00:03:12 +0530
Message-Id: <1233513192.16925.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-01 at 17:49 +0100, Ingo Molnar wrote:
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
> 

I have the patches in queue which fixes above warnings except:

 12 /dev/shm/tip/usr/include/linux/soundcard.h
 1 /dev/shm/tip/usr/include/mtd/jffs2-user.h

Because these two files are using userspace functions.

--
JSR



