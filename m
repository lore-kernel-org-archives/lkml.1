Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbZJIQ1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbZJIQ1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933629AbZJIQ1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:27:40 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:65271 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933569AbZJIQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:27:39 -0400
From: Frans Pop <elendil@planet.nl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Fri, 9 Oct 2009 18:27:00 +0200
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
References: <200910051500.55875.elendil@planet.nl> <200910082259.35204.elendil@planet.nl> <1255070103.7639.30.camel@marge.simson.net>
In-Reply-To: <1255070103.7639.30.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910091827.01774.elendil@planet.nl>
X-OriginalArrivalTime: 09 Oct 2009 16:27:02.0292 (UTC) FILETIME=[54F79D40:01CA48FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 October 2009, Mike Galbraith wrote:
> sched: update the clock of runqueue select_task_rq() selected.
>
> In try_to_wake_up(), we update the runqueue clock, but select_task_rq()
> may select a different runqueue than the one we updated, leaving the new
> runqueue's clock stale for a bit.
>
> This patch cures occasional huge latencies reported by latencytop when
> coming out of idle on a mostly idle NO_HZ box.

This patch (without Arjan's previous one applied) also fixes my latency 
issues. Nice work!

Cheers,
FJP
