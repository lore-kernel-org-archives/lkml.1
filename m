Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZCZCWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZCZCWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZCZCV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:21:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZCZCV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:21:57 -0400
Message-ID: <49CAE64B.4020707@cn.fujitsu.com>
Date: Thu, 26 Mar 2009 10:19:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace_stat: keep original order
References: <49C9F23F.5040307@cn.fujitsu.com> <1237991798.22033.7.camel@localhost.localdomain>
In-Reply-To: <1237991798.22033.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-03-25 at 16:58 +0800, Lai Jiangshan wrote:
>> Impact: make trace_stat files show items with the original order
>>
>> trace_stat tracer reverse the items, it makes the output
>> looks a little ugly.
>>
>> Example, when we read trace_stat/workqueues, we get cpu#7's stat.
>> at first, and then cpu#6... cpu#0.
>>
> 
> This doesn't reverse the order of the annotated branch profiler, does
> it?
> 

The annotated ftrace_branch_data are orderless. So it's OK
with or without this fix.

(From code, not test) If this fix applied,
__start_annotated_branch_profile is shown at the first, and then
__start_annotated_branch_profile + 1... and
__stop_annotated_branch_profile is shown at the last.

Lai

