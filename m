Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYLIUkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYLIUkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbYLIU1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:27:47 -0500
Received: from mail-fx0-f19.google.com ([209.85.220.19]:34742 "EHLO
	mail-fx0-f19.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbYLIU1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:27:45 -0500
X-Greylist: delayed 1494 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 15:27:45 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XihrZICCQEpQYCke9m6AcXNkW0Vv8KeCkmm6mvsaHPR4RFCO/BcnmSSMutEgaMSb17
         jE6yrsQ0grLADuKC9mL4ihPJ/516tZZX1WsfNLiYBm4NFfJQfx0wp5qb/Ea3kkQ5Tgql
         bDaK04meKHf4wZxh48EjszDhmz6NR94BuYosw=
Message-ID: <493ECBC7.4050109@gmail.com>
Date: Tue, 09 Dec 2008 21:49:27 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Frank Ch. Eigler" <fche@redhat.com>, srostedt@redhat.com,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the userspace
 address belongs to
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <y0my6z798de.fsf@ton.toronto.redhat.com> <1227782505.4454.1393.camel@twins> <20081127124851.GC23480@redhat.com> <492E9AB2.9030202@gmail.com> <20081127141054.GB25657@elte.hu> <492EAE65.1040903@gmail.com> <20081127145102.GC4672@elte.hu>
In-Reply-To: <20081127145102.GC4672@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-27 16:51, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> Thanks. I can move on to the lock latency tracing ;)
>>     
>
> that's a bit more contentious ...
>
>   
>> I'll send out a draft of tracepoints that I would need to trace lock 
>> latency. I'll try to put them in same place as lockstat (but not 
>> necesarely depending on lockstat being enabled).
>>     
>
>   
>> Or I could add the tracepoints inside lockstat (now that it has 
>> contend with points feature), and use the information already 
>> gathered by lockstat, but augment it with finer grained counts per 
>> kernel/user stacktrace. (again there would be an ftrace plugin that 
>> would register with the tracepoints, and show the per stacktrace 
>> statistic in /sys/kernel/debug/tracing/trace).
>>     
>
> yes. The less intrusive your patch is, the more you utilize and 
> generalize existing facilities, the better. You could split the 
> Kconfig of LOCKSTAT into two bits: LOCKSTAT (core) and LOCKSTAT_PROC, 
> where the proc bits are enabled separately.
>
> Your tracing approach could then reuse much of core LOCKSTAT (without 
> even touching the code) and just plain "select LOCKSTAT" - without 
> creating /proc/lockdep_stats.
>
> Peter, what do you think?

Ping? I may have some time to work on this in the weekend ...

Best regards,
--Edwin
