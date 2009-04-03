Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZDCHZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZDCHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZDCHZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:25:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46353 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbZDCHZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:25:10 -0400
Date: Fri, 3 Apr 2009 09:25:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403072507.GO5178@kernel.dk>
References: <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02 2009, Linus Torvalds wrote:
> 
> Jens - remind us what the problem with AS was wrt CFQ?

CFQ was just faster, plus it supported things like io priorities that AS
does not.

> There's some write throttling in CFQ, maybe it has some really broken 
> case?

Who knows, it's definitely interesting and something to look into why AS
performs that differently to CFQ on his box. Lennart, can you give some
information on what file system + mount options, disk drive(s), etc? A
full dmesg would be good, too.

> 
> 		Linus
> 
> On Fri, 3 Apr 2009, Lennart Sorensen wrote:
> 
> > On Thu, Apr 02, 2009 at 03:00:44AM +0200, Ingo Molnar wrote:
> > > I'll test this (and the other suggestions) once i'm out of the merge 
> > > window.
> > > 
> > > I probably wont test that though ;-)
> > > 
> > > Going back to v2.6.14 to do pre-mutex-merge performance tests was 
> > > already quite a challenge on modern hardware.
> > 
> > Well after a day of running my mythtv box with anticipatiry rather than
> > the default cfq scheduler, it certainly looks a lot better.  I haven't
> > seen any slowdowns, the disk activity light isn't on solidly (it just
> > flashes every couple of seconds instead), and it doesn't even mind
> > me lanuching bittornado on multiple torrents at the same time as two
> > recordings are taking place and some commercial flagging is taking place.
> > With cfq this would usually make the system unusable (and a Q6600 with
> > 6GB ram should never be unresponsive in my opinion).
> > 
> > So so far I would rank anticipatory at about 1000x better than cfq for
> > my work load.  It sure acts a lot more like it used to back in 2.6.18
> > times.
> > 
> > -- 
> > Len Sorensen
> > 

-- 
Jens Axboe

