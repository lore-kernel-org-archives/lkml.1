Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYFQMUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYFQMUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYFQMUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:20:01 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:9705 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbYFQMUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BbWBvZqxmTsBYwcgF/n1MXY39f/Br+Hyiql4Q27aTjCu74ahy9zfrDPqEr8COnWBIr
         Ftw05go0NpIldOKNofKuAToMLZL+5Jfg2GVnnR4V2KuDbHr2MXblo+J4TKn0jU/uzDQo
         MLplS90CKgXnUxLPbP/FyYUyXUAbNvBVLQSEU=
Message-ID: <4857ABA2.6060801@gmail.com>
Date: Tue, 17 Jun 2008 08:18:42 -0400
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Ankita Garg <ankita@in.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       Peter Zijlstra <peterz@infradead.org>, suresh.b.siddha@intel.com,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, David Bahi <DBahi@novell.com>
Subject: [ANNOUNCE] sched: schedtop utility v0.5
References: <483545B4.BA47.005A.0@novell.com> <48448081.BA47.005A.0@novell.com>
In-Reply-To: <48448081.BA47.005A.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>>> On Thu, May 22, 2008 at 10:06 AM, in message <483545B4.BA47.005A.0@novell.com>,
> Gregory Haskins wrote: 
>> Hi all scheduler developers,
>>   I had an itch to scratch w.r.t. watching the stats in /proc/schedstats, 
>> and it appears that the perl scripts referenced in 
>> Documentation/scheduler/sched-stats.txt do not support v14 from HEAD so I 
>> whipped up a little utility I call "schedtop".
>>
>> This utility will process statistics from /proc/schedstat such that the 
>> busiest stats will bubble up to the top.  It can alternately be sorted by the 
>> largest stat, or by name.  Stats can be included or excluded based on reg-ex 
>> pattern matching.
>>
>> You can download the tarball here:
>>
>> ftp://ftp.novell.com/dev/ghaskins/schedtop.tar.gz
>>
>> I have also posted it to the opensuse build service for generating RPMS for 
>> a handful of 32/64-bit x86 distros for your convenience:
>>
>> http://download.opensuse.org/repositories/home:/ghaskins/
>>
>> (Note that the build is still in progress for some of the favors, so if you 
>> do not see the flavor you are looking for, check back in a little while)
>>
>> Comments/feedback/bug-fixes welcome!
>>
>> Regards
>> -Greg
> 
> Hi All,
>   I have posted an update to schedtop (v0.3) which adds /proc/<pid>/schedstats and /proc/<pid>/sched stats to the mix.
> 
> Also note that there is a comprehensive filtering mechanism built into all versions of schedtop:
> 
> "-i <REGEX>" sets the *include* pattern, and
> "-x <REGEX> sets the *exclude* pattern.
> 
> By default, -i is set to allow everything, and -x is set to exclude nothing.  A common config for me is to use "-x sched_info" since those sched_info stats seem to always be moving rapidly and can cloud stats that are more interesting (to me, anyway).
> 
> Let me know if you have any questions.  Comments/feedback are welcome
> 
> -Greg

Hi All,
  I have released a new version (v0.5) which fixes a compile error on 
some platforms (like Mandriva, RHEL, and opensuse-factory) that did not 
like the usage of operator/ in boost::filesystem::path code.  v0.5 is 
now fully supported on all of the original platforms that v0.2 worked on.

> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

