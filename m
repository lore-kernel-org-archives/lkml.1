Return-Path: <linux-kernel-owner+w=401wt.eu-S934460AbZDCOzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbZDCOzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932759AbZDCOqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:39 -0400
Received: from rtr.ca ([76.10.145.34]:58908 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbZDCOqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:38 -0400
Message-ID: <49D6214A.9030204@rtr.ca>
Date: Fri, 03 Apr 2009 10:46:34 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090401225737.GC3797@csclub.uwaterloo.ca>
In-Reply-To: <20090401225737.GC3797@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Wed, Apr 01, 2009 at 02:36:22PM -0700, Andrew Morton wrote:
>> Back in 2002ish I did a *lot* of work on IO latency, reads-vs-writes,
>> etc, etc (but not fsync - for practical purposes it's unfixable on
>> ext3-ordered)
>>
>> Performance was pretty good.  From some of the descriptions I'm seeing
>> get tossed around lately, I suspect that it has regressed.
>>
>> It would be useful/interesting if people were to rerun some of these
>> tests with `echo anticipatory > /sys/block/sda/queue/scheduler'.
>>
>> Or with linux-2.5.60 :(
> 
> Well 2.6.18 seems to keep popping up as the last kernel with "sane"
> behaviour, at least in terms of not causing huge delays under many
> workloads.  I currently run 2.6.26, although that could be updated as
> soon as I get around to figuring out why lirc isn't working for me when
> I move past 2.6.26.
> 
> I could certainly try changing the scheduler on my mythtv box and seeing
> if that makes any difference to the behaviour.  It is pretty darn obvious
> whether it is responsive or not when starting to play back a video.
..

My Myth box here was running 2.6.18 when originally set up,
and even back then it still took *minutes* to delete large files.
So that part hasn't really changed much in the interim.

Because of the multi-minute deletes, the distro shutdown scripts
would fails, and power off the box while it was still writing
to the drives.  Ouch.

That system has had XFS on it for the past year and a half now,
and for Myth, there's no reason not to use XFS.  It's great!

Cheers

