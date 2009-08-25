Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZHYTxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZHYTxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZHYTxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:53:48 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:42305 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbZHYTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:53:47 -0400
Date: Tue, 25 Aug 2009 12:53:45 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825195345.GF6456@localdomain>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org> <alpine.LFD.2.01.0908251155570.3218@localhost.localdomain> <20090825191231.GA22821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825191231.GA22821@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 09:12:31PM +0200, Ingo Molnar wrote:
>
>* Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
>Furthermore, commit 2759c3287 did not declare any side-effects and 
>clearly causes a side-effect on vSMP which apparently has an 
>overlapping set of initial APIC ids.
>
>Ravikiran, your patch does not do a clear revert of this bit though. 
>If you do a plain revert of the line above alone, does that fix the 
>problem too?
>

Yes it does.  However, it probably reads local apic id when it shouldn't.

I am right now trying out the other patch Yinghai posted (based on
is_vsmp_box()), and report results in a few.

