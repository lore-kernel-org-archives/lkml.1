Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbZEFQk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbZEFQk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZEFQkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:40:12 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:56661
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996AbZEFQkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:40:10 -0400
X-BigFish: VPS-31(z34a4jz1432R62a3L98dR936eQ1805M936fJzz1202hzzz32i6bh15fn61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ8EAH-02-50N-01
Date: Wed, 6 May 2009 18:39:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/2] oprofile: introduce module parameter
	oprofile.cpu_type
Message-ID: <20090506163956.GB31757@erda.amd.com>
References: <1241613554-31539-1-git-send-email-robert.richter@amd.com> <20090506144720.GQ23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090506144720.GQ23223@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 May 2009 16:39:58.0247 (UTC) FILETIME=[4B07F370:01C9CE69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.05.09 16:47:20, Andi Kleen wrote:
> On Wed, May 06, 2009 at 02:39:12PM +0200, Robert Richter wrote:
> > The current userland does not yet fully support all cpu types
> > implemented in the kernel. With the module parameter oprofile.cpu_type
> > a certain cpu type can be reported to the oprofile userland and thus
> > makes the kernel usable with current distros.
> 
> On Intel systems forcing archperfmon is the only one that makes sense
> nd only if the CPU supports arch perfmon(btw that's already in my patchkit
> which you haven't commented on so far)
> 
> I don't thinking forcing core2 on a system like Nehalem with completely
> different events is a good idea though. This just means if the user
> selects anything unusual they will get junk data, which is just
> a bad design.

It is a kernel parameter, and users should know what they are doing
and what the risks are. I assume counting cpu clk unhalted will work
and some other events too. So the patch does not hurt.

> Also if you force core2 on a P4 system the kernel will just oops
> because it will access MSRs that are not there. So I don't think
> that's a good idea.

It anables core_2 only on family 6 (ppro implementation).

> 
> It means you have to update oprofile userland at least once until
> you have arch perfmon support, but I think even Linus will be able
> to do that :) Hopefully Maynard will do a new release soon.

I agree, a new release of the userland would be the best. But till
then it is at least 1-2 months to go.

> The force of core2 is nacked from my side.

I do not have any passion with this patch, What I have in mind is
"oprofile sucks", and this patch would make oprofile more usable.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

