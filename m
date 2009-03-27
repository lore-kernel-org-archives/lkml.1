Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZC0MU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZC0MU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZC0MUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:20:04 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57170 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbZC0MUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:20:03 -0400
Date: Fri, 27 Mar 2009 23:19:52 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bron Gondwana <brong@fastmail.fm>, Matthew Garrett <mjg@redhat.com>,
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
Message-ID: <20090327121952.GB30410@brong.net>
References: <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326185900.166a1097@lxorguk.ukuu.org.uk> <20090326200258.GA10313@srcf.ucam.org> <20090326204209.1da6e791@lxorguk.ukuu.org.uk> <20090326230435.GA10884@brong.net> <20090327112248.2746a4ba@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327112248.2746a4ba@lxorguk.ukuu.org.uk>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 11:22:48AM +0000, Alan Cox wrote:
> > Is this the same Alan Cox who thought a couple of months ago that
> > having an insanely low default maximum number epoll instances was a
> > reasonable answer to a theoretical DoS risk, despite it breaking
> > pretty much every reasonable user of the epoll interface?
> 
> In the short term yes - because security has to be a very high priority.
> Lesser of two evils.

So turn the machine off.

It seems to me that having atime turned on is a DoS risk.  Any punk
can cause lots of disk IO that will make everyone else's fsync's
turn into molasses simply by reading lots of files.  ZOMG (as the
kiddies of today would say) - we'd better fix this DoS risk by
disabling or rate limiting this dangeous vector (eleventyone!)

Bron ( ok, I'm getting a bit silly here - but if we blocked every
       potential DoS by making sure a single user could only use a
       small percentage of the machine's total capacity at maximum... )
