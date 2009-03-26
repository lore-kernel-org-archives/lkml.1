Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbZCZOut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbZCZOut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759209AbZCZOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:49:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:44191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215AbZCZOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:49:10 -0400
Date: Thu, 26 Mar 2009 07:49:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326074955.54add4d3@infradead.org>
In-Reply-To: <20090326143618.GD27476@kernel.dk>
References: <20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326110815.GT27476@kernel.dk>
	<20090326072707.5a98242d@infradead.org>
	<20090326143618.GD27476@kernel.dk>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 15:36:18 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Mar 26 2009, Arjan van de Ven wrote:
> > On Thu, 26 Mar 2009 12:08:15 +0100
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > Did you capture the trace of the long delays in the read test
> > > case? It can be two things, at least. One is that each little
> > > read takes much longer than it should, the other is that we get
> > > stuck waiting on a dirty page and hence that slows down the reads
> > > a lot.
> > > 
> > 
> > would be interesting to run latencytop during such runs...
> 
> Things just drown in the noise in there sometimes, is my experience...
> And disappear. Perhaps I'm just not very good at reading the output,
> but it was never very useful for me. I know, not a very useful
> complaint, I'll try and use it again and come up with something more
> productive :-)
> 
> But in this case, I bet it's also the atime updates. If Ingo turned
> those off, the read results would likely be a lot better (and
> consistent).

latencytop does identify those for sure.
> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
