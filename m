Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZBAQuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZBAQuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZBAQtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:49:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35096 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZBAQtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:49:51 -0500
Date: Sun, 1 Feb 2009 17:49:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090201164915.GA29264@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain> <20090131164410.GA11189@elte.hu> <1233469811.5846.14.camel@localhost.localdomain> <20090201103936.GA30157@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090201103936.GA30157@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > These patches fixes 41 headers_check warnings as shown in first email.
> 
> Pulled into tip/core/header-fixes, thanks Jaswinder!

These are the remaining ones on x86:

     17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
     12 /dev/shm/tip/usr/include/linux/soundcard.h
      6 /dev/shm/tip/usr/include/asm/setup.h
      3 /dev/shm/tip/usr/include/linux/nubus.h
      2 /dev/shm/tip/usr/include/linux/in6.h
      1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
      1 /dev/shm/tip/usr/include/linux/socket.h
      1 /dev/shm/tip/usr/include/linux/coda_psdev.h
      1 /dev/shm/tip/usr/include/asm/prctl.h

They are all of the "extern's make no sense in userspace" type. What was the 
verdict, are they worth touching, or should we turn off this warning in 
'make headers_check'?

	Ingo
