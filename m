Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbXF3OpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbXF3OpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbXF3Oon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:44:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24115 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbXF3Oom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:44:42 -0400
Message-ID: <46866C58.2090705@oracle.com>
Date: Sat, 30 Jun 2007 07:44:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: John Keller <jpk@sgi.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, steiner@sgi.com
Subject: Re: [PATCH] - x86_64-add-ioapic-nmi-support-fix-3
References: <200706301429.l5UETMXk295940@fcbayern.americas.sgi.com>
In-Reply-To: <200706301429.l5UETMXk295940@fcbayern.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Keller wrote:
>> [adding Andi Kleen]
>>
>> John Keller wrote:
>>> Place all the IOACPI NMI support code under CONFIG_ACPI
>>> to clear up build errors with certain configs.
>>>
>>> Signed-off-by: John Keller <jpk@sgi.com>
>>> ---
>> Is there some architectural reason that IO APIC NMI support should
>> require ACPI?
> 
> OK, I guess standing alone this description was a bit misleading.
> The code referred to here is the new code supporting the ACPI NMI SRC
> structure that can be specified in the MADT. Without ACPI support this
> code is not relevant. All the code touched by this patch was introduced
> by eariler versions of this patchset.
> 
> This patch makes no changes to the workings of nmi_watchdog.

OK, thanks for the clarification.

> John
> 
> 
>> Is this a new requirement?  It seems like a step backwards to me.
>>
>>
>> Documentation/nmi_watchdog.txt doesn't say anything about ACPI being
>> needed.  It does say:
>>
>> "For x86-64, the needed APIC is always compiled in, and the NMI watchdog is
>> always enabled with I/O-APIC mode (nmi_watchdog=1). Currently, local APIC
>> mode (nmi_watchdog=2) does not work on x86-64.
>>
>> Using local APIC (nmi_watchdog=2) needs the first performance register, so
>> you can't use it for other purposes (such as high precision performance
>> profiling.) However, at least oprofile and the perfctr driver disable the
>> local APIC NMI watchdog automatically."


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
