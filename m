Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZCWFFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZCWFFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZCWFEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:04:54 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:42633 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZCWFEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:04:53 -0400
Message-ID: <49C7186F.3050403@in.ibm.com>
Date: Mon, 23 Mar 2009 10:34:47 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12792] 2.6.29-rc6-git4 boot failure
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera> <l8NZ2a3iQtG.A.6EB.JaTxJB@chimera> <1237758581.25062.677.camel@pasglop>
In-Reply-To: <1237758581.25062.677.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Sat, 2009-03-21 at 17:39 +0100, Rafael J. Wysocki wrote:
>   
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and let me know
>> (either way).
>>     
>
> Sachin, did you find anything about this one ?
>   
Hi Ben,

I narrowed it down to 2.6.28-git2(Boots) while 2.6.28-git4(fails to boot).
I could not boot test 2.6.28-git3 as i ran into kernel compilation issues.

Here is the error message i got when i tried compiling 2.6.28-git3.

  LD      vmlinux.o
ld: dynreloc miscount for kernel/built-in.o, section .opd
ld: can not edit opd Bad value

I think the above one was some tool chain related issue.

I don't know how to git bisect using these two releases (2.6.28-git2/2.6.28-git4).
I guess that is not possible since there are no commit tags for these releases.
But i could be wrong.

Is there anything else that i could try out to find a solution for this ?
The machine in question is a Power Mac G5 running Ubuntu Hardy with a
PPC970, altivec supported CPU(2).

For the record i can still recreate this issue with 2.6.29-rc8-git6.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

