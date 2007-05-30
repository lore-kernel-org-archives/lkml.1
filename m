Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbXE3CSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbXE3CSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 22:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXE3CS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 22:18:27 -0400
Received: from omta04ps.mx.bigpond.com ([144.140.83.156]:51117 "EHLO
	omta04ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXE3CS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 22:18:26 -0400
Message-ID: <465CDEEA.9060507@bigpond.net.au>
Date: Wed, 30 May 2007 12:18:18 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Con Kolivas <kernel@kolivas.org>, Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <464DA61A.4040406@bigpond.net.au> <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com> <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au> <20070524164538.GA13301@linux-os.sc.intel.com> <46561E67.3030207@bigpond.net.au> <20070529204557.GB3693@linux-os.sc.intel.com> <465CBD35.2000109@bigpond.net.au> <20070530005052.GE3693@linux-os.sc.intel.com>
In-Reply-To: <20070530005052.GE3693@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta08ps.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Wed, 30 May 2007 02:18:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> On Tue, May 29, 2007 at 04:54:29PM -0700, Peter Williams wrote:
>>> I tried with various refresh rates of top too.. Do you see the issue
>>> at runlevel 3 too?
>> I haven't tried that.
>>
>> Do your spinners ever relinquish the CPU voluntarily?
> 
> Nope. Simple and plain while(1); 's
> 
> I can try 32-bit kernel to check.

Don't bother.  I just checked 2.6.22-rc3 and the problem is not present 
which means something between rc2 and rc3 has fixed the problem.  I hate 
it when problems (appear to) fix themselves as it usually means they're 
just hiding.

I didn't see any patches between rc2 and rc3 that were likely to have 
fixed this (but doesn't mean there wasn't one).  I'm wondering whether I 
should do a git bisect to see if I can find where it got fixed?

Could you see if you can reproduce it on 2.6.22-rc2?

Thanks
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
