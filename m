Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZCFVBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZCFVBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZCFVBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:01:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54290 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZCFVBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:01:12 -0500
Subject: Re: Dynamically determine if kernel includes CFS Scheduler
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "lkml," <linux-kernel@vger.kernel.org>
In-Reply-To: <49B18B2E.606@us.ibm.com>
References: <49B18B2E.606@us.ibm.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 22:01:06 +0100
Message-Id: <1236373266.6326.804.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 12:44 -0800, Darren Hart wrote:
> I've received an internal request for a means to determine at run-time 
> if the CFS scheduler is included in the running kernel.  Looking through 
> the git commit log and the /proc/sys/kernel filesystem, I think I see 
> two approaches:
> 
> 1) stat("/proc/sys/kernel/sched_compat_yield")
>     This confirms 2.6.23-rc7 kernel or later which definitely has the CFS
>     scheduler and this functionality is of interest anyway.
> 2) Test if the kernel version is >= 2.6.22 which is where I believe CFS
>     landed.
> 
> Any guesses as to how robust/future-proof approach #1 would be?

The question is why? Relying on scheduler specifics outside of whatever
POSIX mandates is an application bug.

