Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbZL3Jip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbZL3Jip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZL3Jip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:38:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZL3Jio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:38:44 -0500
Message-ID: <4B3B1F3C.8010509@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 17:37:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] perf_event: introduce 'inject' event and get HZ
References: <4B27702F.1080507@cn.fujitsu.com>	 <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com>	 <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>	 <4B3991C1.6060303@cn.fujitsu.com> <1262164786.7135.166.camel@laptop>
In-Reply-To: <1262164786.7135.166.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Tue, 2009-12-29 at 13:21 +0800, Xiao Guangrong wrote:
>> 'inject' event is a very useful feature and it's suggested by Ingo
>> [ See http://lkml.org/lkml/2009/12/28/31 ]
> 
> I really dislike the name, event injection to me would be like a write()
> interface where you provide the actual event data to be stuffed in the
> output stream.
> 

Yes, it like write and it writes something form kernel to perf.
And, i think this name is suitable for it's doing that injects an
'artificial' event, it's well if you have other name for it :-)

> This just seems like a very weird way of getting data out. A kind of
> like sysconf() but done very strange.
> 

It's since some parameter is only used by perf, suce as HZ in this patch and
'relocation offset' in my other patchset, it also well if has better way to
do it :-)

Thanks,
Xiao
