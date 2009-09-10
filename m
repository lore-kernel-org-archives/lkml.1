Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZIJK5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZIJK5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZIJK5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:57:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:48273 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753185AbZIJK5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:57:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ZyH83K/3ZrKLdfOacKq4MgUqyelB8Oz/nnsm5oq
	fbTq9Ov2spQ4cP
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nikos Chantziaras <realnc@arcor.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090910102837.GJ18599@kernel.dk>
References: <20090909091009.GR18599@kernel.dk>
	 <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk>
	 <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de>
	 <20090910060824.GF1335@elte.hu> <20090910064059.GA22646@elte.hu>
	 <20090910095457.GD18599@kernel.dk> <20090910100321.GA7922@elte.hu>
	 <20090910101137.GH18599@kernel.dk>  <20090910102837.GJ18599@kernel.dk>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 12:57:31 +0200
Message-Id: <1252580251.18659.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 12:28 +0200, Jens Axboe wrote:

> No difference. Then I tried switching NO_NEW_FAIR_SLEEPERS on, and then
> I get:
> 
>  Performance counter stats for 'xmodmap .xmodmap-carl':
> 
>        9.009137  task-clock-msecs         #      0.447 CPUs 
>              18  context-switches         #      0.002 M/sec
>               1  CPU-migrations           #      0.000 M/sec
>             315  page-faults              #      0.035 M/sec
>   <not counted>  cycles                  
>   <not counted>  instructions            
>   <not counted>  cache-references        
>   <not counted>  cache-misses            
> 
>     0.020167093  seconds time elapsed
> 
> Woot!

Something is very seriously hosed on that box... clock?

Can you turn it back on, and do..
	while sleep .1; do cat /proc/sched_debug >> foo; done 
..on one core, and (quickly;) xmodmap .xmodmap-carl, then send me a few
seconds worth (gzipped up) to eyeball?

	-Mike

