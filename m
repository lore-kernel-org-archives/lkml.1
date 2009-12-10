Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbZLJId0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbZLJId0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZLJIdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:33:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbZLJIdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:33:19 -0500
Date: Thu, 10 Dec 2009 09:33:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-ID: <20091210083310.GB6834@elte.hu>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
 <20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
 <20091210075454.GB25549@elte.hu>
 <20091210172040.37d259d3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210172040.37d259d3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I'm sorry If I miss your point...are you saying remove all mm_counter 
> completely and remake them under perf ? If so, some proc file 
> (/proc/<pid>/statm etc) will be corrupted ?

No, i'm not suggesting that - i'm just suggesting that right now MM 
stats are not very well suited to be exposed via perf. If we wanted to 
measure/sample the information in /proc/<pid>/statm it just wouldnt be 
possible. We have a few events like pagefaults and a few tracepoints as 
well - but more would be possible IMO.

	Ingo
