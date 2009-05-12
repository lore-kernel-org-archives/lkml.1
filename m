Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZELNlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZELNlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZELNk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:40:58 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:65051 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZELNk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WeGSJb9aEB0sfv0keABAAjkVk4heWPXfwzTCNCLba1udU9GEIJ+bjvamVydyEOPNCk
         UkB7h5MNAxXQtfJp7UHjZ3YcvL6O9Fd5s4m7J/LMQFkhbpp/84JmgiaCKZHPTYMpzG32
         efK7bDQHgEREeoibAH7Mpqly4MaH9mHhmIvps=
MIME-Version: 1.0
In-Reply-To: <20090512132805.GA9808@elte.hu>
References: <20090512102412.GG6351@balbir.in.ibm.com>
	 <20090512102939.GB11714@elte.hu>
	 <20090512193656.D647.A69D9226@jp.fujitsu.com>
	 <20090512132805.GA9808@elte.hu>
Date: Tue, 12 May 2009 22:40:54 +0900
X-Google-Sender-Auth: 12c08fdbd968e7da
Message-ID: <2f11576a0905120640qcecc90ase686095b0d9ef014@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch 
	values for stats counters
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/12 Ingo Molnar <mingo@elte.hu>:
>
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> > or rather, to make cpuacct_batch have a sane value on UP too.
>> > (1? 0?)
>>
>> umm..
>>
>> I've reviewed my patch again.
>> but sched_init() already has multiple #ifdef SMP. [...]
>
> Patches are welcome to remove more of them.
>
>> [...] Thus I don't think cosmetic changing improve readability
>> largely.
>
> an avoidable #ifdef should aways be avoided.

ok. I'll fix it tommorow.
