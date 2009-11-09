Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZKIIir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZKIIir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZKIIir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:38:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49300 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbZKIIiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:38:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 9 Nov 2009 17:36:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] memcg : rewrite percpu countings with new
 interfaces
Message-Id: <20091109173610.3d23daf2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091109070737.GE3042@balbir.in.ibm.com>
References: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
	<20091106175545.b97ee867.kamezawa.hiroyu@jp.fujitsu.com>
	<20091109070737.GE3042@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009 12:37:37 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
 
> > after==
> >  Performance counter stats for './runpause.sh' (5 runs):
> > 
> >   474919.429670  task-clock-msecs         #      7.896 CPUs    ( +-   0.013% )
> >        36520440  page-faults              #      0.077 M/sec   ( +-   1.854% )
> >      3109834751  cache-references         #      6.548 M/sec   ( +-   0.276% )
> >      1053275160  cache-misses             #      2.218 M/sec   ( +-   0.036% )
> > 
> >    60.146585280  seconds time elapsed   ( +-   0.019% )
> > 
> > This test is affected by cpu-utilization but I think more improvements
> > will be found in bigger system.
> >
> 
> Hi, Kamezawa-San,
> 
> Could you please post the IPC results as well? 
> 
Because PREEMPT=n, no differnce between v1/v2, basically.

Here.
==
 Performance counter stats for './runpause.sh' (5 runs):

  475884.969949  task-clock-msecs         #      7.913 CPUs    ( +-   0.005% )
       36592060  page-faults              #      0.077 M/sec   ( +-   0.301% )
     3037784893  cache-references         #      6.383 M/sec   ( +-   0.361% )  (scaled from 99.71%)
     1130761297  cache-misses             #      2.376 M/sec   ( +-   0.244% )  (scaled from 98.24%)

   60.136803969  seconds time elapsed   ( +-   0.006% )
==

But this program is highly affected by cpu utilization etc...

Thanks,
-Kame



