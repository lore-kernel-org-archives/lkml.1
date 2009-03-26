Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZCZMrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZCZMrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZCZMrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:47:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZCZMrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:47:39 -0400
Date: Thu, 26 Mar 2009 13:46:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326124652.GB16499@elte.hu>
References: <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326113705.GV32307@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> Also, can you send me the output of "dumpe2fs -h /dev/sdXX | grep Journal"?

Sure:

 [root@aldebaran ~]# df
 Filesystem           1K-blocks      Used Available Use% Mounted on
 /dev/sda1             40313964  11595520  26670560  31% /
 /dev/sda2            403160732  35165460 347515212  10% /home
 tmpfs                  6159096        48   6159048   1% /dev/shm

 [root@aldebaran ~]# dumpe2fs -h /dev/sda2 | grep Journal
 dumpe2fs 1.40.8 (13-Mar-2008)
 Journal inode:            8
 Journal backup:           inode blocks
 Journal size:             128M

Stock Fedora 9 release/install, updated, and booted to 2.6.29.

	Ingo
