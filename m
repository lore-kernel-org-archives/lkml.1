Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbZCZSzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbZCZSzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbZCZSzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:55:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47408 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757125AbZCZSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:55:31 -0400
Date: Thu, 26 Mar 2009 18:54:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Nottingham <notting@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326185424.6de0ba1b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326173237.GB8465@nostromo.devel.redhat.com>
References: <20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326144707.GA6239@mit.edu>
	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
	<20090326173237.GB8465@nostromo.devel.redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 13:32:38 -0400
Bill Nottingham <notting@redhat.com> wrote:

> Linus Torvalds (torvalds@linux-foundation.org) said: 
> > And quite frankly, even if you then _manually_ put 'relatime' in 
> > /etc/fstab, the default Fedora install will totally ignore it. Why? 
> > Because it mounts the root partition while using initrd, and totally 
> > ignores /etc/fstab.
> 
> It should honor /etc/fstab changes, if the initramfs is rebuilt
> after the change is made. If it doesn't, that's a bug.

Surely it should also look at the real /etc/fstab after mounting root r/o
and then flip the options needed so you don't have to.
