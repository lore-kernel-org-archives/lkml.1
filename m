Return-Path: <linux-kernel-owner+w=401wt.eu-S933942AbZLFRQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942AbZLFRQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZLFRQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:16:32 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50292 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbZLFRQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r8V5QzhfVzR3tuqzYF0ce9nrOWzBH5yzQZPQbERAJEzYyxzljTWe7y546S9gOQ/872
         9VgtYyWQ+eFQuRgt9YarvHn7vdw9Kd26+GqXR8egTESOxwYSpaK1uImGo5qPXyTst/DD
         7hAnzyWwStLABZOjCFIsoepT64qJllWOExjEU=
Message-ID: <4B1BE588.8020608@gmail.com>
Date: Mon, 07 Dec 2009 01:10:32 +0800
From: Xiao Guangrong <ericxiao.gr@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf/sched: fix for getting task's execute time
References: <4B1B8E0E.3040007@cn.fujitsu.com>	 <1260097512.7818.341.camel@laptop> <1260097609.7818.349.camel@laptop>
In-Reply-To: <1260097609.7818.349.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

>> We really should not be using these proc files but instead make sure
>> this information gets transferred through a tracepoint or similar.
>>
>> Reading these proc files is too prone to races.
> 
> We can probably get the runtime by grouping a task-clock swcounter with
> an appropriate other event.
> 

Hi Peter,

Thanks your suggestion.

Actually, we can call getrusage(RUSAGE_THREAD, ru) to get current task's
execute time, and I think this is a simpler way.

I'll send v2 patch later.

Thanks,
Xiao
