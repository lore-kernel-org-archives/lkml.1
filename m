Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbXD1Qaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbXD1Qaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965933AbXD1Qap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:30:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965921AbXD1Qal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:30:41 -0400
Date: Sat, 28 Apr 2007 09:30:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthias Andree <matthias.andree@gmx.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <20070428085148.GC31196@merlin.emma.line.org>
Message-ID: <alpine.LFD.0.98.0704280928530.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
 <20070427113117.98c4f88b.akpm@linux-foundation.org>
 <20070428085148.GC31196@merlin.emma.line.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Matthias Andree wrote:
> 
> Another thing that is rather unpleasant (haven't yet tried fiddling with
> the dirty limits) is UDF to DVD-RAM - try rsyncing /home to a DVD-RAM,
> that's going to leave you with tons of dirty buffers that clear slowly
> -- "watch -n 1 grep -i dirty /proc/meminfo" is boring, but elucidating...

Now *this* is actually really really nasty.

There are worse examples. Try connecting some flash disk over USB-1, and 
untar to it. Ugh.

I'd love to have some per-device dirty limit, but it's harder than it 
should be.

		Linus
