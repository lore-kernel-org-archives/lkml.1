Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZE2Iqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZE2Iqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbZE2Iq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:46:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60519 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbZE2Iq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:46:27 -0400
Date: Fri, 29 May 2009 10:53:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@gmail.com,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: comments on Performance Counters for Linux (PCL)
Message-ID: <20090529085309.GP1065@one.firstfloor.org>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com> <1243527919.6645.75.camel@laptop> <20090529065104.GO1065@one.firstfloor.org> <1243585158.23657.175.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243585158.23657.175.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You're talking about VT stuff, right? 

Yes.

> Does that virtualize the PMU too?

A hypervisor can in software, but another common case is a global profiler on 
the host to be able to profile all guests too. e.g. xenoprofile is able to do 
that.

If you want a full system picture with virtualization that's pretty much 
required.

For that you need a concept of more priviledge levels (host user, host sys,
guest user, guest sys)

> Happen to have more details? If they really run in user context their
> priv level would be the same right, otherwise they run in something
> weird, not quite user not quite kernel. Now that might be the case, but
> I'm utterly ignorant on itanic.

See Documentation/ia64/fsys.txt

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
