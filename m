Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYDANZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYDANZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYDANZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:25:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33846 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYDANZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:25:39 -0400
Date: Tue, 1 Apr 2008 15:29:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
Message-ID: <20080401132924.GI29105@one.firstfloor.org>
References: <47F21BE3.5030705@jp.fujitsu.com> <87zlsdzttp.fsf@basil.nowhere.org> <1207050968.8514.721.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207050968.8514.721.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 01:56:08PM +0200, Peter Zijlstra wrote:
> On Tue, 2008-04-01 at 13:40 +0200, Andi Kleen wrote:
> > Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
> > 
> > > Using cpuset, now we can partition the system into multiple sched domains.
> > > Then, how about providing different characteristics for each domains?
> > 
> > Did you actually see much improvement in any relevant workload
> > from tweaking these parameters?  If yes what did you change?
> > And how much did it gain?
> > 
> > Ideally the kernel should perform well without much tweaking
> > out of the box, simply because most users won't tweak. Adding a 
> > lot of such parameters would imply giving up on good defaults which 
> > is not a good thing.
> 
> >From what I understand they need very aggressive idle balancing; much
> more so than what is normally healty.
> 
> I can see how something like that can be useful when you have a lot of
> very short running tasks. These could pile up on a few cpus and leave
> others idle.

Could the scheduler auto tune itself to this situation?

e.g. when it sees a row of very high run queue inbalances increase the
frequency of the idle balancer?

-Andi
