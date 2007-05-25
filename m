Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbXEYIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbXEYIh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXEYIhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:37:21 -0400
Received: from holomorphy.com ([66.93.40.71]:55881 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbXEYIhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:37:19 -0400
Date: Fri, 25 May 2007 01:38:13 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] i386, numaq: enable TSCs again
Message-ID: <20070525083813.GA19966@holomorphy.com>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080827.GA22399@elte.hu> <20070525081944.GZ31925@holomorphy.com> <20070525083153.GA27236@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525083153.GA27236@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> I remember. It was far beyond "slightly async;" they would drift 
>> minutes apart during reasonable amounts of uptime, though it would 
>> take at least several days to drift so far (I don't recall how long it 
>> took).

On Fri, May 25, 2007 at 10:31:53AM +0200, Ingo Molnar wrote:
> yes, that's what i meant under 'slightly async'. Some AMD CPUs are like 
> that too and sched_clock() now handles that fine. So we should try my 
> patch.

Sorry, then. I took slight to mean something else. In any event I was
only quantifying things. I've no opinion whatsoever on the impact of
the code on NUMA-Q, only some recall of its operating characteristics.


-- wli
