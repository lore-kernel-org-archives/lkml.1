Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0BDCdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:33:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0BDCdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:33:37 -0500
Message-ID: <4B6A316B.3040509@cn.fujitsu.com>
Date: Thu, 04 Feb 2010 10:31:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: using O_LARGEFILE to open perf data file
  - fix
References: <4B68F32A.9040203@cn.fujitsu.com> <4B6958B8.3000606@cn.fujitsu.com> <20100203131911.GA25223@elte.hu>
In-Reply-To: <20100203131911.GA25223@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> Setting _FILE_OFFSET_BITS and using O_LARGEFILE, lseek64, etc, is
>> redundant. Thanks H. Peter Anvin for point out
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  tools/perf/builtin-record.c        |    3 +--
>>  tools/perf/util/header.c           |   21 ++++++++++-----------
>>  tools/perf/util/session.c          |    3 +--
>>  tools/perf/util/trace-event-read.c |   14 +++++++-------
>>  4 files changed, 19 insertions(+), 22 deletions(-)
> 
> i already applied the v1 patch - mind sending a delta patch that removes the 
> redundant definitions?
> 

Hi Ingo,

This patch is the delta patch, i used the _FILE_OFFSET_BITS defining and removed
O_LARGEFILE/lseek64 to keep code clean.

I'll integrate Peter's comments and send the new version.

Thanks,
Xiao 
