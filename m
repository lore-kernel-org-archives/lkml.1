Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZLBIMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZLBIMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZLBIMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:12:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:36887 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZLBIM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:12:29 -0500
Message-ID: <4B161F3D.3040202@windriver.com>
Date: Wed, 02 Dec 2009 16:03:09 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, mhiramat@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  perf tools: Add _GNU_SOURCE macro for strndup()
References: <1259734306-26323-1-git-send-email-liming.wang@windriver.com> <4B161F83.6090804@cn.fujitsu.com>
In-Reply-To: <4B161F83.6090804@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2009 08:11:58.0698 (UTC) FILETIME=[1E8D5CA0:01CA7327]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong wrote:
> 
> Liming Wang wrote:
>> strndup is a GNU extension. So add _GNU_SOURCE macro
>> to avoid compiling error.
>>
>> Signed-off-by: Liming Wang <liming.wang@windriver.com>
>> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  tools/perf/util/string.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
>> index 0977cf4..ea3eb39 100644
>> --- a/tools/perf/util/string.c
>> +++ b/tools/perf/util/string.c
>> @@ -1,5 +1,8 @@
>> +#define _GNU_SOURCE
>>  #include <string.h>
>>  #include <stdlib.h>
>> +
>> +#undef _GNU_SOURCE
> 
> I think those two "#include" can be removed,
> because util.h include it.
Agreed. It's a better method.

Liming Wang
> 
>>  #include "string.h"
>>  #include "util.h"
>>  
> 

