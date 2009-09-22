Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbZIVJ2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbZIVJ2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZIVJ2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:28:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60488 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbZIVJ2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:28:37 -0400
Message-ID: <4AB89892.3080603@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 17:27:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: cleanup for __perf_event_sched_in()
References: <4AB88F06.10900@cn.fujitsu.com> <19128.38623.956765.684792@cargo.ozlabs.ibm.com>
In-Reply-To: <19128.38623.956765.684792@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Mackerras wrote:
> Xiao Guangrong writes:
> 
>> It must be a group leader if event->attr.pinned is "1"
> 
> True, but you shouldn't use BUG_ON unless there is no sensible way for
> the kernel to continue executing, and that's not the case here.  Make
> it WARN_ON, or better still, WARN_ON_ONCE.
> 

Yeah, thanks for you point out, I'll fix it soon.

Thanks,
Xiao

