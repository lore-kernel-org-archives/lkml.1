Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbXENI0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbXENI0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761856AbXENI0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:26:30 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:2442 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbXENI03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:26:29 -0400
Message-ID: <46481D18.7080302@de.ibm.com>
Date: Mon, 14 May 2007 10:26:00 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: + timer_stats-slimmed-down-using-statistics-infrastucture.patch
 added to -mm tree
References: <200704210018.l3L0IJBN027188@shell0.pdx.osdl.net> <1179082720.19106.4.camel@laptopd505.fenrus.org>
In-Reply-To: <1179082720.19106.4.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 2007-04-20 at 17:18 -0700, akpm@linux-foundation.org wrote:
>> The patch titled
>>      timer_stats slimmed down: using statistics infrastucture
>> has been added to the -mm tree.  Its filename is
>>      timer_stats-slimmed-down-using-statistics-infrastucture.patch
>>
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>
>> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
>> out what to do about this
>>
>> ------------------------------------------------------
>> Subject: timer_stats slimmed down: using statistics infrastucture
>> From: Martin Peschke <mp3@de.ibm.com>
>>
>> This patch implements timer_stats based on the statistics infrastructure.
>>
>> Here is some sample output, which even somewhat
>> resembles /proc/timer_stats.
>> (>80 char lines because of symbol names, sorry for line breaks).
>>
>> It reads:
>> <statistic name> <basket> <hits> <label>
>>
>> with label being:
>> <pid> <task name> <start_fn>(<stop_fn>)
>>
>> [root@t2930041 timer_stats]# cat data
> 
> this patch changes the userspace API though, and breaks PowerTOP :(

Though I think it was unfortunate to add the "old" proc API in 2.6.21.
timer_stats is clearly labeled as debug stuff in config help, which is why 
debugfs would have been a proper place.


