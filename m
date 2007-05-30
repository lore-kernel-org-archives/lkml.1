Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbXE3G2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbXE3G2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 02:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXE3G2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 02:28:31 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:39182 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbXE3G2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 02:28:30 -0400
Message-ID: <465D1987.7030600@bigpond.net.au>
Date: Wed, 30 May 2007 16:28:23 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Con Kolivas <kernel@kolivas.org>, Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au> <20070524164538.GA13301@linux-os.sc.intel.com> <46561E67.3030207@bigpond.net.au> <20070529204557.GB3693@linux-os.sc.intel.com> <465CBD35.2000109@bigpond.net.au> <20070530005052.GE3693@linux-os.sc.intel.com> <465CDEEA.9060507@bigpond.net.au> <20070530044201.GF3693@linux-os.sc.intel.com>
In-Reply-To: <20070530044201.GF3693@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Wed, 30 May 2007 06:28:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> On Tue, May 29, 2007 at 07:18:18PM -0700, Peter Williams wrote:
>> Siddha, Suresh B wrote:
>>> I can try 32-bit kernel to check.
>> Don't bother.  I just checked 2.6.22-rc3 and the problem is not present
>> which means something between rc2 and rc3 has fixed the problem.  I hate
>> it when problems (appear to) fix themselves as it usually means they're
>> just hiding.
>>
>> I didn't see any patches between rc2 and rc3 that were likely to have
>> fixed this (but doesn't mean there wasn't one).  I'm wondering whether I
>> should do a git bisect to see if I can find where it got fixed?
>>
>> Could you see if you can reproduce it on 2.6.22-rc2?
> 
> No. Just tried 2.6.22-rc2 64-bit version at runlevel 3 on my remote
> system at office. 15 attempts didn't show the issue.
> 
> Sure that nothing changed in your test setup?
> 

I just rechecked with an old kernel and the problem was still there.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
