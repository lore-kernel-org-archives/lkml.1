Return-Path: <linux-kernel-owner+w=401wt.eu-S1763688AbXE2TdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763688AbXE2TdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbXE2Tcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:32:54 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbXE2Tcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:32:53 -0400
Date: Tue, 29 May 2007 12:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>, Christoph Lameter <christoph@lameter.com>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-Id: <20070529123223.068eb97e.akpm@linux-foundation.org>
In-Reply-To: <20070524075601.GB21138@elte.hu>
References: <4651FC58.mailxOWT1QTGD9@eag09.americas.sgi.com>
	<20070523104315.6b9089dc.akpm@linux-foundation.org>
	<20070524075601.GB21138@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 09:56:01 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > When a cpu is disabled, move_task_off_dead_cpu() is called for tasks 
> > > that have been running on that cpu.
> > 
> > So I still have these three patches in the pending queue but I was 
> > rather hoping that the scheduler, sched-domains and cpuset people 
> > could take a look at them, please.
> > 
> > They hit sched.c and cpuset.c mainly, and they might trash Ingo's CFS 
> > patch (I haven't checked).
> 
> The patch looks good to me. It applies cleanly ontop of CFS and it 
> builds and boots fine with and without CONFIG_CPU_HOTPLUG (although i 
> havent tried to explicitly stress the codepath in question). We are a 
> bit paranoid in this codepath but it's not performance-critical 
> normally.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 

I applied this to -mm, thanks.

The other two patches don't apply well to the current pending patch queue
and nobody seems keen on doing a serious review (or any review, iirc), so I
ducked them.

