Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbXHER4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbXHER4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXHER4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:56:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32917 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbXHER4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:56:45 -0400
Date: Sun, 5 Aug 2007 19:55:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Claudio Martins <ctpm@ist.utl.pt>, Jeff Garzik <jeff@garzik.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805175547.GC3244@elte.hu>
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu> <200708050051.40758.ctpm@ist.utl.pt> <20070805014926.400d0608@the-village.bc.nu> <20070805144645.GA28263@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805144645.GA28263@thunk.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> If you are always reading from the same small set of files (i.e., a 
> database workload), then those inodes only get updated every 5 seconds 
> (the traditional/default metadata update sync time, as well as the 
> default ext3 journal update time), it's no big deal.  Or if you are 
> running a mail server, most of the time the mail queue files are 
> getting updated anyway as you process them, and usually the mail is 
> delivered before 5 seconds is up anyway.
> 
> So earlier, when Ingo characterized it as, "whenever you read from a 
> file, even one in memory cache.... do a write!", it's probably a bit 
> unfair.  Traditional Unix systems simply had very different workload 
> characteristics than many modern dekstop systems today.

yeah, i didnt mean to say that it is _always_ a big issue, but "only a 
small number of files are read" is a very, very small minority of even 
the database server world.

	Ingo
