Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbYHORh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbYHORh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYHORht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:37:49 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:42720 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYHORhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:37:48 -0400
Message-ID: <1734.69.2.248.210.1218820443.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1151.69.2.248.210.1218817564.squirrel@webmail.wolfmountaingroup.com>
References: <200808140614.m7E6EcDS006264@wolfmountaingroup.com>   
    <84144f020808140139v691e6590idd79995168af4e9e@mail.gmail.com>   
    <44303.166.70.238.45.1218724556.squirrel@webmail.wolfmountaingroup.com>
       <20080815122510.GF20442@elte.hu>   
    <1763.69.2.248.210.1218815934.squirrel@webmail.wolfmountaingroup.com>  
     <20080815163916.GB16560@elte.hu>
    <1151.69.2.248.210.1218817564.squirrel@webmail.wolfmountaingroup.com>
Date: Fri, 15 Aug 2008 11:14:03 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc3 26/29] mdb: export task_curr
From: jmerkey@wolfmountaingroup.com
To: jmerkey@wolfmountaingroup.com
Cc: "Ingo Molnar" <mingo@elte.hu>, jmerkey@wolfmountaingroup.com,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       jason.wessel@windriver.com
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> * jmerkey@wolfmountaingroup.com <jmerkey@wolfmountaingroup.com> wrote:
>>
>>> >
>>> > * jmerkey@wolfmountaingroup.com <jmerkey@wolfmountaingroup.com>
>>> wrote:
>>> >
>>> >> > On Thu, Aug 14, 2008 at 9:14 AM,  <jmerkey@wolfmountaingroup.com>
>>> >> wrote:
>>> >> >> export the task_curr function to the module based kernel debugger
>>> to
>>> >> >> enable
>>> >> >> process back tracing and state display.
>>> >> >>
>>> >> >> Signed-off-by: Jeffrey Vernon Merkey
>>> (jmerkey@wolfmountaingroup.com)
>>> >> >>
>>> >> >> --- a/kernel/sched.c    2008-08-13 14:22:32.000000000 -0600
>>> >> >> +++ b/kernel/sched.c    2008-08-13 11:56:03.000000000 -0600
>>> >> >> @@ -1736,6 +1736,9 @@
>>> >> >>  {
>>> >> >>        return cpu_curr(task_cpu(p)) == p;
>>> >> >>  }
>>> >> >> +#if defined(CONFIG_MDB_MODULE)
>>> >> >> +EXPORT_SYMBOL_GPL(task_curr);
>>> >> >> +#endif
>>> >> >
>>> >> > We usually don't export symbols conditionally, especially in core
>>> >> kernel
>>> >> > code.
>>> >> >
>>> >>
>>> >> Well,then please suggest how a kernel debugger can be module based
>>> and
>>> >> still be able to get this information some other way that's generic
>>> >> and minimal impact.
>>> >
>>> > FYI, there's a built-in kernel debugger in the upstream kernel
>>> already:
>>> > kernel/kgdb.c - and it does not need that export.
>>> >
>>> > So if you are interested in kernel debuggers i'd suggest to work with
>>> > the KGDB folks to extend it with whatever feature-set is missing.
>>> >
>>> > They are friendly, very easy to work with and are open to the
>>> > thousands-of-years-old scientific method of not duplicating effort,
>>> > working together, going forward gradually, etc.
>>> >
>>> > 	Ingo
>>> >
>>>
>>> Sorry, but I have my own path and direction, [...]
>>
>> doing things alone is your unalienable personal right, and since thus
>> you apparently didnt intend your patch to be included in the Linux
>> kernel that's as far as my interest in this as a maintainer goes.
>>
>> Thanks,
>>
>> 	Ingo
>>


I removed the export from this file and will resubmit the patch series. 
This will remove you from the decision list for this patch series.  What
other files do you claim to maintain so I can make certain remove them
from my patches?

I can get the variable some other way.

:-)

Thanks

Jeff




