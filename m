Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZDCEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZDCEST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 00:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZDCESI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 00:18:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbZDCESF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 00:18:05 -0400
Date: Thu, 2 Apr 2009 21:13:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090403040649.GF3795@csclub.uwaterloo.ca>
Message-ID: <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain>
References: <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu>
 <20090403040649.GF3795@csclub.uwaterloo.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jens - remind us what the problem with AS was wrt CFQ?

There's some write throttling in CFQ, maybe it has some really broken 
case?

		Linus

On Fri, 3 Apr 2009, Lennart Sorensen wrote:

> On Thu, Apr 02, 2009 at 03:00:44AM +0200, Ingo Molnar wrote:
> > I'll test this (and the other suggestions) once i'm out of the merge 
> > window.
> > 
> > I probably wont test that though ;-)
> > 
> > Going back to v2.6.14 to do pre-mutex-merge performance tests was 
> > already quite a challenge on modern hardware.
> 
> Well after a day of running my mythtv box with anticipatiry rather than
> the default cfq scheduler, it certainly looks a lot better.  I haven't
> seen any slowdowns, the disk activity light isn't on solidly (it just
> flashes every couple of seconds instead), and it doesn't even mind
> me lanuching bittornado on multiple torrents at the same time as two
> recordings are taking place and some commercial flagging is taking place.
> With cfq this would usually make the system unusable (and a Q6600 with
> 6GB ram should never be unresponsive in my opinion).
> 
> So so far I would rank anticipatory at about 1000x better than cfq for
> my work load.  It sure acts a lot more like it used to back in 2.6.18
> times.
> 
> -- 
> Len Sorensen
> 
