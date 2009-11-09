Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZKIHEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZKIHEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZKIHEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:04:23 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36054 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZKIHEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:04:22 -0500
Date: Mon, 9 Nov 2009 12:34:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] memcg make use of new percpu implementations
Message-ID: <20091109070421.GD3042@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091106175242.6e13ee29.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-11-06 17:52:42]:

> Hi,
> 
> Recent updates on dynamic percpu allocation looks good and I tries to rewrite
> memcg's poor implementation of percpu status counter.
> (It's not NUMA-aware ...)
> Thanks for great works.
> 
> For this time. I added Christoph to CC because I'm not fully sure my usage of
> __this_cpu_xxx is correct...I'm glad if you check the usage when you have time.
> 
> 
> Patch 1/2 is just clean up (prepare for patch 2/2)
> Patch 2/2 is for percpu.
> 
> Tested on my 8cpu box and works well.
> Pathcesa are against the latest mmotm.

How do the test results look? DO you see a significant boost? BTW,
I've been experimenting a bit with the earlier percpu counter patches,
I might post an iteration once I have some good results.

-- 
	Balbir
