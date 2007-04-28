Return-Path: <linux-kernel-owner+w=401wt.eu-S1161751AbXD1Ivx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161751AbXD1Ivx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161771AbXD1Ivx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:51:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:54954 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161751AbXD1Ivw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:51:52 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX19Wv7AEcq5Wt5I47dPZ6y1UFy8gxoByAgp1gBT2qj
	QDhs/z7Ki2rd6c
Date: Sat, 28 Apr 2007 10:51:48 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
Message-ID: <20070428085148.GC31196@merlin.emma.line.org>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <1177660767.6567.41.camel@Homer.simpson.net> <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org> <20070427113117.98c4f88b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427113117.98c4f88b.akpm@linux-foundation.org>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:

> But none of this explains a 20-minute hang, unless a *lot* of fsyncs are
> being performed, perhaps.

Another thing that is rather unpleasant (haven't yet tried fiddling with
the dirty limits) is UDF to DVD-RAM - try rsyncing /home to a DVD-RAM,
that's going to leave you with tons of dirty buffers that clear slowly
-- "watch -n 1 grep -i dirty /proc/meminfo" is boring, but elucidating...

-- 
Matthias Andree
