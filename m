Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbZCZXE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbZCZXE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZCZXEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:04:47 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34067 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761662AbZCZXEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:04:45 -0400
Date: Fri, 27 Mar 2009 10:04:35 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326230435.GA10884@brong.net>
References: <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326185900.166a1097@lxorguk.ukuu.org.uk> <20090326200258.GA10313@srcf.ucam.org> <20090326204209.1da6e791@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326204209.1da6e791@lxorguk.ukuu.org.uk>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 08:42:09PM +0000, Alan Cox wrote:
> > before performing the update. So while relatime doesn't conform, the 
> > practical difference is meaningless. You can't depend on atime being 
> > updated in a timely manner.
> 
> POSIX says a disk write interrupted by a signal can be a short write. If
> you do this in practice all hell breaks loose.
> 
> A conforming implementation needs to conform with expectations not just
> play lawyer games with users systems.

Is this the same Alan Cox who thought a couple of months ago that
having an insanely low default maximum number epoll instances was a
reasonable answer to a theoretical DoS risk, despite it breaking
pretty much every reasonable user of the epoll interface?

Bron ( what stable interface? )
