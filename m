Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZLWLwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZLWLwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 06:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZLWLwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 06:52:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:43003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZLWLwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 06:52:20 -0500
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b9df5fa10912230335r459f86d4te868fca82b891752@mail.gmail.com>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
	 <1261563687.4937.120.camel@laptop>
	 <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
	 <1261565584.4937.124.camel@laptop>
	 <b9df5fa10912230335r459f86d4te868fca82b891752@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 12:51:52 +0100
Message-ID: <1261569112.4937.135.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 17:35 +0600, Rakib Mullick wrote:
> Yes - current heuristics does this - to make sure that it doesn't have to
> wait too long. It pushes process into another runqueue (probably less loaded)
> just to make sure that - it will get the CPU a bit quickly. But when a task
> got the CPU - we should keep it out of equation. The point of moving task
> is - it have to wait less. At exec current task don't have to wait to get CPU.

No, moving tasks isn't (primarily) about latency, it is about ensuring a
fair proportion of service time.

Do you have a particular workload you worry about or are you merely
trying to satisfy your curiosity?


