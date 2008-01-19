Return-Path: <linux-kernel-owner+w=401wt.eu-S1763734AbYASFen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763734AbYASFen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYASFeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:34:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYASFeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:34:36 -0500
Date: Sat, 19 Jan 2008 06:37:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool II
Message-ID: <20080119053758.GC28467@one.firstfloor.org>
References: <4790E3A6.7060807@linux.intel.com> <p73lk6m9ze7.fsf@bingen.suse.de> <47918792.2080201@linux.intel.com> <20080119052709.GA28467@one.firstfloor.org> <479189BF.2000403@linux.intel.com> <20080119053330.GB28467@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119053330.GB28467@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 06:33:30AM +0100, Andi Kleen wrote:
> > another thing that the current profiling can't do, is to show what the 
> > system is doing
> > when it hits the latency.. so someone calling fsync() will show up in the 
> > waiting for
> > IO function, but not that it was due to an fsync().
> 
> Hmm so how about extending oprofile to always log the syscall number
> in the event logs (can be gotten from top of stack). I think given

Ok to handle exceptions like page faults this way you would need to save
the vector somewhere on entry, but that shouldn't be very costly 
or difficult and could probably even be done unconditionally.

-Andi
