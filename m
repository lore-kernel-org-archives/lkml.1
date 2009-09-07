Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZIGUqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZIGUqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZIGUqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:46:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49553 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZIGUqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:46:43 -0400
Date: Mon, 7 Sep 2009 22:46:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907204645.GK18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <4AA54AA7.9080709@redhat.com> <20090907184640.GG18599@kernel.dk> <20090907203627.GA17731@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907203627.GA17731@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Agree, I was actually looking into doing joint latency for X 
> > number of tasks for the test app. I'll try and do that and see if 
> > we can detect something from that.
> 
> Could you please try latest -tip:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> (c26f010 or later)
> 
> Does it get any better with make -j128 build jobs? Peter just fixed 

The compile 'problem' is on my workstation, which is a dual core Intel
core 2. I use -j4 on that typically. On the bigger boxes, I don't notice
any interactivity problems, largely because I don't run anything latency
sensitive on those :-)

> a bug in the SMP load-balancer that can cause interactivity problems 
> on large CPU count systems.

Worth trying on the dual core box?

-- 
Jens Axboe

