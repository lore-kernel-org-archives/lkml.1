Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754047AbYLNSIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYLNSIT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Sun, 14 Dec 2008 13:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYLNSIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:08:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40740 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYLNSID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:08:03 -0500
Date: Thu, 1 Jan 1970 01:13:43 +0100
From: Pavel Machek <pavel@suse.cz>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v5 0/7] Tunable sched_mc_power_savings=n
Message-ID: <19700101001343.GA1440@ucw.cz>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Results:
> --------
> 
> Basic functionality of the code has not changed and the power vs
> performance benefits for kernbench are similar to the ones posted
> earlier.
> 
> KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
> package system
> 
> SchedMC Run Time     Package Idle    Energy  Power
> 0	81.28	     52.43% 53.53%  1.00x J 1.00y W
> 1	80.71	     37.35% 68.91%  0.96x J 0.97y W
> 2	76.05	     23.81% 82.65%  0.92x J 0.98y W
> 
> *** This is RFC code and not for inclusion ***

Hmm, so it makes it compile faster _and_ it saves power? Why to keep
it tunable at all if it is win-win? Or are there other benchmarks?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
