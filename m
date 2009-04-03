Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbZDCPPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbZDCPPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932867AbZDCPO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:14:58 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43631 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932669AbZDCPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:14:57 -0400
Date: Fri, 3 Apr 2009 11:14:55 -0400
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403151455.GI3795@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D625A0.1030202@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 11:05:04AM -0400, Mark Lord wrote:
> I wonder if the problem with your system is really a Myth/driver issue?

Could be.  That is the point of the box after all.

> Curiously, I have a HVR-1600 card here, and when recording analog TV with
> it the disk lights are on constantly.  The problem with it turns out to
> be mythbackend doing fsync() calls ten times a second.

But why would anticipatory help that?

> My other tuner cards don't have this problem.
>
> So perhaps the PVR-500 triggers the same buggy behaviour as the HVR-1600?
> To work around it here, I decided to use a preload library that replaces
> the frequent fsync() calls with a more moderated behaviour:
>
>   http://rtr.ca/hvr1600/libfsync.tar.gz
>
> Grab that file and try it out.  Instructions are included within.
> Report back again and let us know if it makes any difference.

I can have a try at that.  I will see how cfq behaves with that installed.

> Someday I may try and chase down the exact bug that causes mythbackend
> to go fsyncing berserk like that, but for now this workaround is fine.

Well if it is the real cause of the bad behaviour then it would certainly
be good to track down.

-- 
Len Sorensen
