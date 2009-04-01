Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbZDAW5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbZDAW5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbZDAW5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:57:40 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56938 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757304AbZDAW5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:57:40 -0400
Date: Wed, 1 Apr 2009 18:57:38 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-ID: <20090401225737.GC3797@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401143622.b1885643.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 02:36:22PM -0700, Andrew Morton wrote:
> Back in 2002ish I did a *lot* of work on IO latency, reads-vs-writes,
> etc, etc (but not fsync - for practical purposes it's unfixable on
> ext3-ordered)
> 
> Performance was pretty good.  From some of the descriptions I'm seeing
> get tossed around lately, I suspect that it has regressed.
> 
> It would be useful/interesting if people were to rerun some of these
> tests with `echo anticipatory > /sys/block/sda/queue/scheduler'.
> 
> Or with linux-2.5.60 :(

Well 2.6.18 seems to keep popping up as the last kernel with "sane"
behaviour, at least in terms of not causing huge delays under many
workloads.  I currently run 2.6.26, although that could be updated as
soon as I get around to figuring out why lirc isn't working for me when
I move past 2.6.26.

I could certainly try changing the scheduler on my mythtv box and seeing
if that makes any difference to the behaviour.  It is pretty darn obvious
whether it is responsive or not when starting to play back a video.

-- 
Len Sorensen
