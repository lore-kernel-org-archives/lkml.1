Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZCZRwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZCZRwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZCZRwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:52:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbZCZRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:52:22 -0400
Date: Thu, 26 Mar 2009 10:41:37 -0700 (PDT)
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
In-Reply-To: <20090326173237.GB8465@nostromo.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.0903261039480.3032@localhost.localdomain>
References: <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
 <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326173237.GB8465@nostromo.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Bill Nottingham wrote:

> Linus Torvalds (torvalds@linux-foundation.org) said: 
> > And quite frankly, even if you then _manually_ put 'relatime' in 
> > /etc/fstab, the default Fedora install will totally ignore it. Why? 
> > Because it mounts the root partition while using initrd, and totally 
> > ignores /etc/fstab.
> 
> It should honor /etc/fstab changes, if the initramfs is rebuilt
> after the change is made. If it doesn't, that's a bug.

Why the hell should I rebuild initramfs? 

Anyway, I fixed it. I don't use initramfs any more, after all the idiocies 
it has done. I had to make everything primary partitions in order to do 
that, but hey, that solved a lot of other problems too, so that was no 
loss.

			Linus
