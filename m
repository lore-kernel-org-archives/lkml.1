Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbXKWKRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbXKWKRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbXKWKRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:17:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:52210 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754492AbXKWKRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:17:41 -0500
X-Authenticated: #18865375
X-Provags-ID: V01U2FsdGVkX18fCzslvq0f18+JobIXyTJ4EzOkZwfJF9B428qHbi
	7n/Qt6lc9KjLbu
Message-ID: <4746A8BE.8030703@gmx.de>
Date: Fri, 23 Nov 2007 11:17:34 +0100
From: Ansgar Knappheide <ansgar.knappheide@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.5) Gecko/20070716 Thunderbird/2.0.0.5 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: steve@tuxsoft.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc2 displays incorrect DVD description
References: <1354.72.205.227.110.1194986901.squirrel@www.tuxsoft.com> <20071123003557.36a126bd.akpm@linux-foundation.org>
In-Reply-To: <20071123003557.36a126bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
> (cc linux-ide)
>
> On Tue, 13 Nov 2007 15:48:21 -0500 (EST) steve@tuxsoft.com wrote:
>
>   
>> For example, 2.6.23.1:
>>
>> Linux version 2.6.23.1 (root@jupiter) (gcc version 4.2.2) #1 SMP PREEMPT
>> Fri Oct 26 13:09:09 CDT 2007
>> kernel: hdd: HP DVD Writer 1040d, ATAPI CD/DVD-ROM drive
>> kernel: hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache,
>> UDMA(66)
>>
>> and
>>
>> 2.6.24-rc2:
>>
>> Linux version 2.6.24-rc2 (ironman@jupiter) (gcc version 4.2.2) #1 SMP
>> PREEMPT Fri Nov 9 20:41:37 CST 2007
>> kernel: hdd: HP DVD Writer 1040d, ATAPI CD/DVD-ROM drive
>> kernel: hdd: ATAPI 126X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache,
>> UDMA(66)
>>
>> The drive seems to work correctly, reading and writing just fine.  I just
>> happened to notice this and thought I'd pass it along.
>>
>> One other odd thing while looking through the logs, 2.6.23.1 has also
>> reported the drive as follows:
>>
>> Linux version 2.6.23.1 (root@jupiter) (gcc version 4.2.2) #1 SMP PREEMPT
>> Fri Oct 26 13:09:09 CDT 2007
>> kernel: hdd: HP DVD Writer 1040d, ATAPI CD/DVD-ROM drive
>> kernel: hdd: ATAPI 32X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache,
>> UDMA(66)
>>
>> Any idea what is going on here?  It's being reported as 48X, 126X, and 32X.
>>
>>     
>
>   
If it's only the speed value in the description, perhaps you had 
different medias (no medium, CD-ROM, DVD-VIDEO, CD-R, CD-RW, ...) on 
this bootups in your drive, I have seen this changed speed value 
depending on insert medium in the past on some Liteon or Samsung drive.

MBR
Ansgar Knappheide
