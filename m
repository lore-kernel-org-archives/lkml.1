Return-Path: <linux-kernel-owner+w=401wt.eu-S1763574AbYASFaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763574AbYASFaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYASFaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:30:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37191 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYASFaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:30:09 -0500
Date: Sat, 19 Jan 2008 06:33:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
Message-ID: <20080119053330.GB28467@one.firstfloor.org>
References: <4790E3A6.7060807@linux.intel.com> <p73lk6m9ze7.fsf@bingen.suse.de> <47918792.2080201@linux.intel.com> <20080119052709.GA28467@one.firstfloor.org> <479189BF.2000403@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479189BF.2000403@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> another thing that the current profiling can't do, is to show what the 
> system is doing
> when it hits the latency.. so someone calling fsync() will show up in the 
> waiting for
> IO function, but not that it was due to an fsync().

Hmm so how about extending oprofile to always log the syscall number
in the event logs (can be gotten from top of stack). I think given
that you could reconstruct that data in the userland at least
for single threads (not for work done on behalf of them in other
threads; but I'm not sure you tried to solve that problem at all)

The advantage is that it would be an generic mechanism that would work
for all types of profiling.

-Andi
> 
