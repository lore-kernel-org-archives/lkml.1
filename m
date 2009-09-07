Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbZIGVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbZIGVFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZIGVFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:05:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZIGVFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:05:48 -0400
Date: Mon, 7 Sep 2009 23:05:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907210550.GL18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <4AA54AA7.9080709@redhat.com> <20090907184640.GG18599@kernel.dk> <20090907203627.GA17731@elte.hu> <20090907204645.GK18599@kernel.dk> <1252357417.7959.52.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252357417.7959.52.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07 2009, Peter Zijlstra wrote:
> On Mon, 2009-09-07 at 22:46 +0200, Jens Axboe wrote:
> > > a bug in the SMP load-balancer that can cause interactivity problems 
> > > on large CPU count systems.
> > 
> > Worth trying on the dual core box?
> 
> I debugged the issue on a dual core :-)
> 
> It should be more pronounced on larger machines, but its present on
> dual-core too.

Alright, I'll upgrade that box to -tip tomorrow and see if it makes
a noticable difference. At -j4 or higher, I can literally see windows
slowly popping up when switching to a different virtual desktop.

-- 
Jens Axboe

