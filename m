Return-Path: <linux-kernel-owner+w=401wt.eu-S1161778AbXD1I7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161778AbXD1I7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161787AbXD1I7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:59:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161778AbXD1I7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:59:20 -0400
Date: Sat, 28 Apr 2007 01:59:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Message-Id: <20070428015912.6108dbd5.akpm@linux-foundation.org>
In-Reply-To: <20070428085148.GC31196@merlin.emma.line.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	<20070427113117.98c4f88b.akpm@linux-foundation.org>
	<20070428085148.GC31196@merlin.emma.line.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 10:51:48 +0200 Matthias Andree <matthias.andree@gmx.de> wrote:

> On Fri, 27 Apr 2007, Andrew Morton wrote:
> 
> > But none of this explains a 20-minute hang, unless a *lot* of fsyncs are
> > being performed, perhaps.
> 
> Another thing that is rather unpleasant (haven't yet tried fiddling with
> the dirty limits) is UDF to DVD-RAM - try rsyncing /home to a DVD-RAM,
> that's going to leave you with tons of dirty buffers that clear slowly
> -- "watch -n 1 grep -i dirty /proc/meminfo" is boring, but elucidating...
> 

yes, a few people are attacking that from various angles at present.  It's
tricky - writeback has to juggle a lot of balls.  We'll get there.

