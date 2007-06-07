Return-Path: <linux-kernel-owner+w=401wt.eu-S965706AbXFGAWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965706AbXFGAWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965063AbXFGAWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:22:04 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:15123 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbXFGAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:22:03 -0400
Message-ID: <46674FA6.8060904@de.ibm.com>
Date: Thu, 07 Jun 2007 02:21:58 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jbaron@redhat.com,
       rostedt@goodmis.org, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <20070606231041.GB11592@elte.hu>
In-Reply-To: <20070606231041.GB11592@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Martin Peschke <mp3@de.ibm.com> wrote:
> 
>> - lock_time_inc() vs. statistic_add_util()
> 
> please fix the coding style in lib/statistic.c. It's full of:
> 
> {
>         unsigned long long i;
>         if (value <= stat->u.histogram.range_min)
>                 return 0;
> 
> put a newline after variable sections.
> 
> and:
> 
>         on_each_cpu(_statistic_barrier, NULL, 0, 1);
>         return 0;
> 
> preferably use a newline before 'return' statements as well. (this is 
> not always necessary, but in the above case it looks better)

Will do (in my local tree, for the time being).

Good points. Thnaks for reviewing.


	Martin

