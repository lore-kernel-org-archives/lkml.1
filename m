Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbXEGMoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbXEGMoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933663AbXEGMoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:44:14 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:6331 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662AbXEGMoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:44:13 -0400
Message-ID: <463F1F11.8060508@de.ibm.com>
Date: Mon, 07 May 2007 14:44:01 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, swen@vnet.ibm.com
Subject: Re: [RFC] [Patch 3/3] readahead statistics slimmed down
References: <1178214999.5639.79.camel@dix> <f6b15c890705050255l7ab6fb42y93714a6da8b3d2b5@mail.gmail.com>
In-Reply-To: <f6b15c890705050255l7ab6fb42y93714a6da8b3d2b5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu wrote:
> 2007/5/3, Martin Peschke <mp3@de.ibm.com>:
>>
>> This patch implements the bulk of the existing the adaptive readahead
>> statistics with lib/statistics.c.
>>
>> The output format differs somewhat as the the statistics code just emits
>> lists of items and doesn't do tables. It is feasible to leave
>> reformating and beautification to some user scripts, if needed. This
>> patch omits some summary data, most of which can be done in user space
>> as well.
>>
>> Sample output (from dd'ing a disk):
>>
>> cache_miss.total 0 0
>> cache_miss.initial 0 0
>> cache_miss.clock 10 10
>> cache_miss.context 0 0
> 
> 
> Martin,
> 
> The new form of readahead statistics is appreciated. The code is much
> simpler and the output is suitable for scripting. Thank you for doing the
> conversion.
> 
> Me too have trimmed out the original ra_events_show() stuff based on your
> patches. However, later on it becomes obvious that the current adaptive
> readahead patch needs non-trivial rework. So the accounting patches were 
> put
> off. Expect to see them in the adaptive readahead kernel module ;-)
> 
> Thank you,
> Fengguang Wu

I have been wondering whether this one might be worth staging in -mm along with 
the other readahead patches. It would be work be work in progress like the other 
readahead patches. But I leave this decision to you and Andrew.

THanks for the positive feedback.

Martin

