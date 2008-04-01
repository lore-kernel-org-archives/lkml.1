Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbYDAL43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbYDAL43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYDAL4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:56:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32845 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYDAL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:56:21 -0400
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
In-Reply-To: <87zlsdzttp.fsf@basil.nowhere.org>
References: <47F21BE3.5030705@jp.fujitsu.com>
	 <87zlsdzttp.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 13:56:08 +0200
Message-Id: <1207050968.8514.721.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 13:40 +0200, Andi Kleen wrote:
> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
> 
> > Using cpuset, now we can partition the system into multiple sched domains.
> > Then, how about providing different characteristics for each domains?
> 
> Did you actually see much improvement in any relevant workload
> from tweaking these parameters?  If yes what did you change?
> And how much did it gain?
> 
> Ideally the kernel should perform well without much tweaking
> out of the box, simply because most users won't tweak. Adding a 
> lot of such parameters would imply giving up on good defaults which 
> is not a good thing.

>From what I understand they need very aggressive idle balancing; much
more so than what is normally healty.

I can see how something like that can be useful when you have a lot of
very short running tasks. These could pile up on a few cpus and leave
others idle.


