Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZCZO00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZCZO00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbZCZO0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:26:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:41243 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbZCZO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:26:18 -0400
Date: Thu, 26 Mar 2009 07:27:07 -0700
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
Message-ID: <20090326072707.5a98242d@infradead.org>
In-Reply-To: <20090326110815.GT27476@kernel.dk>
References: <20090324041249.1133efb6.akpm@linux-foundation.org>
	<20090325123744.GK23439@duck.suse.cz>
	<20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326110815.GT27476@kernel.dk>
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

On Thu, 26 Mar 2009 12:08:15 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> Did you capture the trace of the long delays in the read test case? It
> can be two things, at least. One is that each little read takes much
> longer than it should, the other is that we get stuck waiting on a
> dirty page and hence that slows down the reads a lot.
> 

would be interesting to run latencytop during such runs...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
