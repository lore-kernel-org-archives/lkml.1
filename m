Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZLJIrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZLJIrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZLJIrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:47:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZLJIrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:47:43 -0500
Message-ID: <4B20B54F.1080207@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 16:46:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf sched: Add max delay time snapshot
References: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com> <4B206A18.2030607@cn.fujitsu.com> <20091210072351.GF16874@elte.hu> <4B20AE32.1090602@cn.fujitsu.com> <20091210082719.GA6834@elte.hu>
In-Reply-To: <20091210082719.GA6834@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:

> Actually, i think the natural solution here is not any ugly interaction 
> between two largely disjunct sets of APIs, but a new feature: to turn 
> the function tracer into an event.
> 
> That would allow perf sched to also record function traces if so 
> desired. And it would also allow a whole lot of other things - mixing 
> function tracer events and other events.

It's a useful feature! :-)

Thanks,
Xiao
