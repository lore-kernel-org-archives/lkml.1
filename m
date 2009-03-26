Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZCZRZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZCZRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZCZRZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:25:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbZCZRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:25:18 -0400
Date: Thu, 26 Mar 2009 10:16:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
In-Reply-To: <20090326170714.GF6239@mit.edu>
Message-ID: <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
References: <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
 <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Theodore Tso wrote:
> 
> You can, actually, but it requires hacking /boot/grub/menu.list.  The
> boot command option "rootflags=noatime" should do it, if their initrd
> scripts are at all sane (and they honor rootfstype, so they probably
> do also honor rootflags).

Not when I tried it. It just causes the initrd to be mounted noatime, and 
then the real root filesystem gets mounted atime again.

Maybe I screwed up. But I don't think so.

> The question is whether we can make Fedora 11 and OpenSUSE do the
> right thing now that this has become a highly visible discussion.  I'm
> actually fairly optimistic on this front.  (Maybe some distro folks
> will care to chime in on whether upcoming releases of F11 and OpenSuSE
> can be changed to DTRT?)

And what's the argument for not doing it in the kernel?

The fact is, "atime" by default is just wrong.

			Linus
