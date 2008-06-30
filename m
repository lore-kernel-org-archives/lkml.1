Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYF3HK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYF3HK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYF3HKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:10:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:14830 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYF3HKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i3rOKFNHGkTpzSEZtMAa/iA9wVs9lrTbDvkbv90+kokERZJig1ZjseVwGRQd04sRVf
         4We7kaoH0UFw2p6uaIHfIHqIXk5Nst93+3krxiXNxTLJ+zsvSbtklANwsrUxBsZmqxfB
         mnu+kOhmw8CTteuL3+ryantLxyrloTUgoOr9g=
Message-ID: <cfd18e0f0806300010n2141fd39s3983143c9aeb97b8@mail.gmail.com>
Date: Mon, 30 Jun 2008 09:10:44 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] doc: Document the relax_domain_level kernel boot argument
Cc: "Paul Jackson" <pj@sgi.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       Lee.Schermerhorn@hp.com,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <48687871.3040407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080630045640.20308.22031.sendpatchset@polaris-admin.engr.sgi.com>
	 <48687871.3040407@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 8:08 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Paul Jackson wrote:
>> From: Paul Jackson <pj@sgi.com>
>>
>> Document the kernel boot parameter: relax_domain_level=.
>>
>> Signed-off-by: Paul Jackson <pj@sgi.com>
>>
>> ---
>>  Documentation/cpusets.txt           |    3 +++
>>  Documentation/kernel-parameters.txt |    4 ++++
>>  2 files changed, 7 insertions(+)
>>
>> --- 2.6.26-rc5-mm3.orig/Documentation/cpusets.txt     2008-06-27 06:55:34.000000000 -0700
>> +++ 2.6.26-rc5-mm3/Documentation/cpusets.txt  2008-06-29 21:49:53.984674621 -0700
>> @@ -546,6 +546,9 @@ otherwise initial value -1 that indicate
>>   ( 4  : search nodes in a chunk of node [on NUMA system] )
>>   ( 5~ : search system wide [on NUMA system])
>>
>> +The system default is 0 (no search).  The system default can be
>> +changed using the relax_domain_level= boot parameter.
>> +
>>  This file is per-cpuset and affect the sched domain where the cpuset
>>  belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
>>  is disabled, then 'sched_relax_domain_level' have no effect since
>> --- 2.6.26-rc5-mm3.orig/Documentation/kernel-parameters.txt   2008-06-27 06:28:26.000000000 -0700
>> +++ 2.6.26-rc5-mm3/Documentation/kernel-parameters.txt        2008-06-29 21:51:10.477997208 -0700
>> @@ -1732,6 +1732,10 @@ and is between 256 and 4096 characters.
>>                       Format: <reboot_mode>[,<reboot_mode2>[,...]]
>>                       See arch/*/kernel/reboot.c or arch/*/kernel/process.c
>>
>> +     relax_domain_level=
>> +                     [KNL, SMP] Set schedulers default relax_domain_level.
>> +                     See Documentation/cpusets.txt.
>> +
>
> is [KNL,SMP] more consistent ?
>
> and s/schedulers/scheduler's/
>
> but maybe I'm wrong due to my English skill.

You are right.  (Paul doesn't like apostrophes ;-).)

>>       reserve=        [KNL,BUGS] Force the kernel to ignore some iomem area
>>
>>       reservetop=     [X86-32]
>>
>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
