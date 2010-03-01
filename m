Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab0CAOkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:40:13 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:53866
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751056Ab0CAOkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:40:11 -0500
X-SpamScore: -33
X-BigFish: VPS-33(zz146fK1432R98dN936eM179dN62a3Lzz1202hzzz32i2a8h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYLY2A-02-091-02
X-M-MSG: 
Date: Mon, 1 Mar 2010 15:39:46 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 00/15] oprofile fixes and updates for v2.6.34
Message-ID: <20100301143946.GE13205@erda.amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
 <20100227090331.GA22839@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100227090331.GA22839@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Mar 2010 14:39:46.0809 (UTC) FILETIME=[0A311690:01CAB94D]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.02.10 10:03:31, Ingo Molnar wrote:
> Hm, the perf_event.c bits conflict quite heavily with pending changes in 
> tip:perf/core.
> 
> So to not hold up the oprofile changes for v2.6.34 i've pulled the core 
> oprofile changes for v2.6.34 into tip:oprofile (up to cfc9c0b, if that is fine 
> with you), and mind reworking the last 3 patches against perf/core?

Ingo & Peter,

I have a rebased version containing also a merge from:

 tip/oprofile -> tip/perf/core

Please pull again from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

> 
> On a related note, wrt. your ongoing work for perf IBS support. The following 
> patch by Peter:
> 
>   f22f54f: perf_events, x86: Split PMU definitions into separate files

Yes, the patches went also upstream on Friday. Will update my current
patch stack now. Maybe it would have been better to first integrate
all pending patches before doing that split. Conflict resolution is a
pain for moving code. But anyway, it is supposed to go upstream and I
will rebase my patches.

> 
> Will probably interact with those patches.
> 
> As usual you can avoid such interactions and conflicts by pushing any pending 
> bits to Peter and me earlier. It can even be disabled temporarily (if that can 
> be done cleanly), if IBS support is not fully working yet.

Hmm, I was working with latest tip/perf/core, but I was waiting with
my submission for Peter's quilt queue since I know there were
conflicts again.

I will start submitting patches now relative to latest
tip/perf/core. There shouldn't be more patches flying around.

I decided to send the perf_event.h changes via the oprofile tree since
tip/perf/core was not stable enough. The patches contain cross
subsystem changes and are not only for perf. Perf-only patches I wont
send upstream via oprofile.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

