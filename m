Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZIHMFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZIHMFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZIHMFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:05:04 -0400
Received: from lo.gmane.org ([80.91.229.12]:38989 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbZIHMFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:05:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el_es <el.es.cr@gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Tue, 8 Sep 2009 12:00:08 +0000 (UTC)
Message-ID: <loom.20090908T135340-799@post.gmane.org>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu> <20090907232415.GA17182@ee.oulu.fi> <20090908080427.GA7070@elte.hu> <4AA6123F.7020704@arcor.de> <20090908101221.GA21533@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.165.152.76 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo <at> elte.hu> writes:


> For example 'Compile' latencies:
> 
> --- Benchmarking simulated cpu of Audio in the presence of simulated Load
>                   Latency +/- SD (ms)  Max Latency   % Desired CPU  %
Deadlines Met
>  v2.6.30: Compile   0.003 +/- 0.00426    0.014             100            100
>      BFS: Compile   0.007 +/- 0.00751    0.019             100            100
> 
> but ... with a near 100% standard deviation that's pretty hard to 
> judge. The Max Latency went from 14 usecs under v2.6.30 to 19 usecs 
> on BFS.
> 
[...]
> 	Ingo
> 

This just struck me : maybe what desktop users *feel* is exactly that : current
approach is too fine-grained, trying to achieve the minimum latency with *most*
reproductible result (less stddev) at all cost ? And BFS just doesn't care? 
I know this sounds like heresy.

[ the space below is to satisfy the brain-dead GMane posting engine].










Lukasz



