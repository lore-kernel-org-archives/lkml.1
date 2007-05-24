Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbXEXH4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbXEXH4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXEXH4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:56:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511AbXEXH4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:56:23 -0400
Date: Thu, 24 May 2007 09:56:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>, Christoph Lameter <christoph@lameter.com>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070524075601.GB21138@elte.hu>
References: <4651FC58.mailxOWT1QTGD9@eag09.americas.sgi.com> <20070523104315.6b9089dc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523104315.6b9089dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > When a cpu is disabled, move_task_off_dead_cpu() is called for tasks 
> > that have been running on that cpu.
> 
> So I still have these three patches in the pending queue but I was 
> rather hoping that the scheduler, sched-domains and cpuset people 
> could take a look at them, please.
> 
> They hit sched.c and cpuset.c mainly, and they might trash Ingo's CFS 
> patch (I haven't checked).

The patch looks good to me. It applies cleanly ontop of CFS and it 
builds and boots fine with and without CONFIG_CPU_HOTPLUG (although i 
havent tried to explicitly stress the codepath in question). We are a 
bit paranoid in this codepath but it's not performance-critical 
normally.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
