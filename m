Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbXIXPkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbXIXPkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbXIXPju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:39:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:34801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881AbXIXPjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:39:49 -0400
Date: Mon, 24 Sep 2007 17:39:46 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070924153946.GI4608@v2.random>
References: <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <20070916181504.GB16406@skynet.ie> <20070916185052.GG6708@v2.random> <87lkb643ug.fsf@informatik.uni-tuebingen.de> <20070918193102.GC7541@v2.random> <87d4w97tug.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4w97tug.fsf@informatik.uni-tuebingen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 08:56:39AM +0200, Goswin von Brederlow wrote:
> As a user I know it because I didn't put a kernel source into /tmp. A
> programm can't reasonably know that.

Various apps requires you (admin/user) to tune the size of their
caches. Seems like you never tried to setup a database, oh well.

> Xen has its own memory pool and can quite agressively reclaim memory
> from dom0 when needed. I just ment to say that the number in

The whole point is if there's not enough ram of course... this is why
you should check.

> /proc/meminfo can change in a second so it is not much use knowing
> what it said last minute.

The numbers will change depending on what's running on your
system. It's up to you to know plus I normally keep vmstat monitored
in the background to see how the cache/free levels change over
time. Those numbers are worthless if they could be fragmented...

> I would kill any programm that does that to find out how much free ram
> the system has.

The admin should do that if he's unsure, not a program of course!
