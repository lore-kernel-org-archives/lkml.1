Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZC3OxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZC3OxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZC3OxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:53:10 -0400
Received: from smtp27.orange.fr ([80.12.242.94]:1482 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZC3OxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:53:09 -0400
X-ME-UUID: 20090330145304581.8DE2E20000A2@mwinf2704.orange.fr
Subject: Re: [PATCH 2/2] Make relatime default
From: Xavier Bestel <xavier.bestel@free.fr>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20090330144213.GA5426@random.random>
References: <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu>
	 <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu>
	 <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
	 <20090326170714.GF6239@mit.edu>
	 <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
	 <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org>
	 <20090326184838.26166549@lxorguk.ukuu.org.uk>
	 <20090330144213.GA5426@random.random>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 16:52:33 +0200
Message-Id: <1238424753.27596.503.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 16:42 +0200, Andrea Arcangeli wrote:
> On Thu, Mar 26, 2009 at 06:48:38PM +0000, Alan Cox wrote:
> > On Thu, 26 Mar 2009 17:53:14 +0000
> > Matthew Garrett <mjg@redhat.com> wrote:
> > 
> > > Change the default behaviour of the kernel to use relatime for all
> > > filesystems. This can be overridden with the "strictatime" mount
> > > option.
> > 
> > NAK this again
> 
> NAK but because if we change the default it is better to change it to
> the real thing: noatime.
> 
> I think this can be solved in userland but perhaps changing this in
> kernel would be a stronger message that atime is officially
> obsoleted. (and nothing will break, not even mutt users will notice,
> and if they really do it won't be anything more than aesthetical)

Actually I liked the previous relatime (without the 24h hack) pretty
much. It would have preserved the atime functionality without making
something like slocate dirty huge parts of the fs daily.

I vote for relatime-without-24h-hack !

	Xav


