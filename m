Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbZLUB2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbZLUB2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbZLUB2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:28:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60527 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZLUB2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:28:48 -0500
Message-ID: <4B2ECF41.3030601@cn.fujitsu.com>
Date: Mon, 21 Dec 2009 09:28:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] tracing: Fix bugs in string filters.
References: <4B25B797.1040201@cn.fujitsu.com> <20091214123955.GK5168@nowhere>
In-Reply-To: <20091214123955.GK5168@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Dec 14, 2009 at 11:57:11AM +0800, Li Zefan wrote:
>> This patchset fixes some bugs in string filters.
>>
>> A new string helper strnstr() is introduced, to be used in
>> middle matching callback.
>>
>> Also I add some comments to mainly explain why we should use
>> length-limited version of strstr() and strcmp().
>>
>> ---
>>  include/linux/string.h             |    5 ++++-
>>  kernel/trace/ftrace.c              |    6 +++---
>>  kernel/trace/trace_events_filter.c |   29 ++++++++++++++++++++---------
>>  lib/string.c                       |   27 ++++++++++++++++++++++++++-
>>  4 files changed, 53 insertions(+), 14 deletions(-)
> 
> 
> Looks pretty good.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 

Hi Steven, could you pick up those patches?

