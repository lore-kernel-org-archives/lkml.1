Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYLaLzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYLaLzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYLaLzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:55:13 -0500
Received: from relay2.sgi.com ([192.48.179.30]:40245 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755172AbYLaLzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:55:12 -0500
Message-ID: <495B5D9D.8020803@sgi.com>
Date: Wed, 31 Dec 2008 03:55:09 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] cpumask: fix compile error in kernel/irq/proc.c
References: <495B345A.5080302@cn.fujitsu.com> <200812312136.40502.rusty@rustcorp.com.au>
In-Reply-To: <200812312136.40502.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 31 December 2008 19:29:06 Li Zefan wrote:
>> diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
>> index 2abd3a7..5a5ac60 100644
>> --- a/kernel/irq/proc.c
>> +++ b/kernel/irq/proc.c
>> @@ -111,7 +111,7 @@ static ssize_t default_affinity_write(struct file *file,
>>  	if (err)
>>  		goto out;
>>  
>> -	if (!is_affinity_mask_valid(new_value)) {
>> +	if (!is_affinity_mask_valid(*new_value)) {
>>  		err = -EINVAL;
>>  		goto out;
>>  	}
> 
> This looks like one for Mike: I have *new_value in the cpumask tree.
> 
> Mike?
> 
> Thanks,
> Rusty.

I have the old value, but then I don't have any affinity changes in my
tree.  Aren't those all in your cpumask tree?

Thanks,
Mike
