Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbXLGWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbXLGWDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXLGWDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:03:15 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48856 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbXLGWDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:03:14 -0500
Message-ID: <4759C31D.30003@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 03:33:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <4759BCBA.7060800@linux.vnet.ibm.com> <4759BE88.3020702@linux.vnet.ibm.com> <200712072258.19331.arnd@arndb.de>
In-Reply-To: <200712072258.19331.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 07 December 2007, Balbir Singh wrote:
>> Balbir Singh wrote:
>>> Geert Uytterhoeven wrote:
>>>> On Sat, 8 Dec 2007, Balbir Singh wrote:
>>>>> +   if (strstr(p, "fake="))
>>>>> +           cmdline = p + 5;        /* 5 is faster than strlen("fake=") */
>>>> Really? My gcc is smart enough to replace the `strlen("fake=")' by 5, even
>>>> without -O.
>>>>
>>> Thanks for pointing that out, but I am surprised that a compiler would
>>> interpret library routines like strlen.
>>>
>> I just tested it and it turns out that you are right. I'll go hunt to
>> see where gcc gets its magic powers from.
>>
> 
> Even if it wasn't: Why the heck would you want to optimize this? The function
> is run _once_ at boot time and the object code gets thrown away afterwards!
> 
> 	Arnd <><

Cause, I see no downside of doing it. The strlen of fake= is fixed.
But having said that, I am not a purist about the approach, I just want
cmdline to point after "fake="

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
