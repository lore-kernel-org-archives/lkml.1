Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbZCZWfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbZCZWfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZCZWfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:35:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbZCZWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:35:05 -0400
Date: Thu, 26 Mar 2009 15:24:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bill Nottingham <notting@redhat.com>
cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
In-Reply-To: <20090326182320.GA9341@nostromo.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.0903261523060.3032@localhost.localdomain>
References: <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu>
 <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326173237.GB8465@nostromo.devel.redhat.com> <alpine.LFD.2.00.0903261039480.3032@localhost.localdomain> <20090326182320.GA9341@nostromo.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Bill Nottingham wrote:
> 
> Well, it's got to find the root fs options somewhere. Pulling them
> from the modified /etc/fstab in the root fs before you mount it, well...

Umm.

The _only_ sane thng to do is to mount the root read-only from initramfs, 
and then re-mount it with the options in the /etc/fstab later when you 
re-mount it read-write _anyway_ (which may possibly be immediately, of 
course).

Anybody who thinks you should re-write initramfs for something like this 
really hasn't spent a single second thinking about it.

		Linus
