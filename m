Return-Path: <linux-kernel-owner+w=401wt.eu-S1765039AbYASFf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765039AbYASFf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYASFfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:35:17 -0500
Received: from mga06.intel.com ([134.134.136.21]:4012 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983AbYASFfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:35:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,220,1199692800"; 
   d="scan'208";a="327068298"
Message-ID: <47918BFF.9010804@linux.intel.com>
Date: Fri, 18 Jan 2008 21:34:55 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
References: <4790E3A6.7060807@linux.intel.com> <p73lk6m9ze7.fsf@bingen.suse.de> <47918792.2080201@linux.intel.com> <20080119052709.GA28467@one.firstfloor.org> <479189BF.2000403@linux.intel.com> <20080119053330.GB28467@one.firstfloor.org>
In-Reply-To: <20080119053330.GB28467@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> another thing that the current profiling can't do, is to show what the 
>> system is doing
>> when it hits the latency.. so someone calling fsync() will show up in the 
>> waiting for
>> IO function, but not that it was due to an fsync().
> 
> Hmm so how about extending oprofile to always log the syscall number
> in the event logs (can be gotten from top of stack).

syscall nr and pid at minimum then.
Still doesn't work for modules either.

what it ends up doing is using an entirely different interface for basically the
same code / operation inside the kernel.
The current interface code is maybe 80 lines of /proc code... and very simple to
use (unlike the oprofile interface)
