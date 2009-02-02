Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbZBBSI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbZBBSI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZBBSIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:08:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZBBSIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:08:45 -0500
Date: Mon, 2 Feb 2009 19:08:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090202180811.GC1394@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain> <20090131164410.GA11189@elte.hu> <1233469811.5846.14.camel@localhost.localdomain> <20090201103936.GA30157@elte.hu> <20090201164915.GA29264@elte.hu> <8bd0f97a0902020911h6cc45be0m8b2affb5a531d160@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0902020911h6cc45be0m8b2affb5a531d160@mail.gmail.com>
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


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Sun, Feb 1, 2009 at 11:49, Ingo Molnar wrote:
> > These are the remaining ones on x86:
> >
> >     17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
> >     12 /dev/shm/tip/usr/include/linux/soundcard.h
> >      6 /dev/shm/tip/usr/include/asm/setup.h
> >      3 /dev/shm/tip/usr/include/linux/nubus.h
> >      2 /dev/shm/tip/usr/include/linux/in6.h
> >      1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
> >      1 /dev/shm/tip/usr/include/linux/socket.h
> >      1 /dev/shm/tip/usr/include/linux/coda_psdev.h
> >      1 /dev/shm/tip/usr/include/asm/prctl.h
> >
> > They are all of the "extern's make no sense in userspace" type. What was 
> > the verdict, are they worth touching, or should we turn off this warning 
> > in 'make headers_check'?
> 
> the warning wouldnt have been added if it didnt make sense ... like it 
> says, prototypes for kernel functions make no sense in userspace headers

the existence of a warning does not justify it. For example the CONFIG_* 
warnings were deemed largely bogus and were removed.

	Ingo
