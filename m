Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYI3QrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYI3QrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYI3Qqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:46:50 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58248 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYI3Qqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:46:48 -0400
Message-ID: <48E257B9.8020509@ct.jp.nec.com>
Date: Tue, 30 Sep 2008 09:45:45 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH -tip] sched: fix using uninilialzed rq in	task_delta_exec()
References: <48E11D0D.3040000@ct.jp.nec.com> <20080930085850.GA27452@elte.hu>
In-Reply-To: <20080930085850.GA27452@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> compiler warnings;
>>
>>   CC      kernel/sched.o
>> kernel/sched.c: In function 'task_delta_exec':
>> kernel/sched.c:4055: warning: unused variable 'flags'
>> kernel/sched.c:4054: warning: 'rq' is used uninitialized in this function
>>
>> calling task_delta_exec() may cause unexpected pointer access.
> 
> heh, just fixed that as well, latest tip/master should have the fix.
> 
> Have you seen any weirdness due to this uninitialized variable?

No I've never seen any problem yesterday.
And I didn't have much time to use tip tree yesterday:)

Today's looks good.

thanks,
Hiroshi Shimamoto
