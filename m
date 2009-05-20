Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZETL62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZETL62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZETL6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:58:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36178 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbZETL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:58:17 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
From: Andi Kleen <andi@firstfloor.org>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com>
	<1242722454.26820.461.camel@twins>
	<20090519084852.GA13682@sli10-desk.sh.intel.com>
	<1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins>
	<alpine.LFD.2.00.0905191429440.29241@localhost.localdomain>
	<1242772601.26820.527.camel@twins>
Date: Wed, 20 May 2009 13:58:16 +0200
In-Reply-To: <1242772601.26820.527.camel@twins> (Peter Zijlstra's message of "Wed, 20 May 2009 00:36:41 +0200")
Message-ID: <87ljosnfzb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

Peter, in general the discussion would be much more fruitful
if you explained your reasoning more verbosely. I can only guess
what your rationales are from your half sentence 
pronouncements.

> and has no regards for any realtime processes.

You're saying this should not be done if any realtime processes are
currently bound to a to be temporarily removed CPU?

That sounds reasonable and I'm sure could be implemented
with the original patch.

> And I must take back my
> earlier suggestion, hotplug is a bad solution too.
>
> There's just too much user policy (cpuset configuration) to upset.

Could you explain that please? How does changing the top level
cpuset affect other cpu sets?

> The IBM folks are working on a scheduler based solution, please talk to
> them.

I don't claim to fully understand the scheduler, but naively since
cpusets can already do this adding another mechanism for it too that
needs to be checked in fast paths would seem somewhat redundant?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
