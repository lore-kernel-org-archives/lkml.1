Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZFVMBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZFVMBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZFVMBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:01:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43592 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZFVMBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:01:00 -0400
Date: Mon, 22 Jun 2009 14:00:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: IV.3 - AMD IBS
Message-ID: <20090622120018.GR24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 3/ AMD IBS
>
> How is AMD IBS going to be implemented?
>
> IBS has two separate sets of registers. One to capture fetch
> related data and another one to capture instruction execution
> data. For each, there is one config register but multiple data
> registers. In each mode, there is a specific sampling period and
> IBS can interrupt.
>
> It looks like you could define two pseudo events or event types
> and then define a new record_format and read_format. That formats
> would only be valid for an IBS event.
>
> Is that how you intend to support IBS?

That is indeed one of the ways we thought of, not really nice, but
then, IBS is really weird, what were those AMD engineers thinking
:-)

The point is - weird hardware gets expressed as a ... weird feature
under perfcounters too. Not all hardware weirdnesses can be
engineered away.
