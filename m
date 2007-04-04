Return-Path: <linux-kernel-owner+w=401wt.eu-S1030371AbXDDDha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371AbXDDDha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030380AbXDDDha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:37:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12795 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030371AbXDDDh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:37:29 -0400
Message-ID: <46131D86.4070607@oracle.com>
Date: Tue, 03 Apr 2007 20:37:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <24083.1175650554@turing-police.cc.vt.edu>            <20070403192004.986b44ec.randy.dunlap@oracle.com> <4963.1175654767@turing-police.cc.vt.edu>
In-Reply-To: <4963.1175654767@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 03 Apr 2007 19:20:04 PDT, Randy Dunlap said:
>> On Tue, 03 Apr 2007 21:35:54 -0400 Valdis.Kletnieks@vt.edu wrote:
>>> I do a '/ACPI_SLEEP' inside that, and I get this output:
>>>
>>> x Symbol: ACPI_SLEEP [=n]                                                 x
>>>   x   Depends on: !X86_NUMAQ && !X86_VISWS && !IA64_HP_SIM && (IA64 || X86)
> 
>>> Only problem is that drivers/acpi/Kconfig:49 says:
>>>
>>> config ACPI_SLEEP
>>>         bool "Sleep States"
>>>         depends on X86 && (!SMP || SUSPEND_SMP)
>>>         depends on PM
>>>         default y
>>>
>>> Can somebody explain why I'm seeing the different Depends on in the two places?
>> Due to the top of drivers/acpi/Kconfig:
>>
>> menu "ACPI (Advanced Configuration and Power Interface) Support"
>> 	depends on !X86_NUMAQ
>> 	depends on !X86_VISWS
>> 	depends on !IA64_HP_SIM
>> 	depends on IA64 || X86
>> 	depends on PM
> 
> Ah. Further investigation shows that the "&& (!SMP || SUSPEND_SMP)" part
> failed to show up because the line was too long - running 'make menuconfig'
> in an 140-col or so xterm made them show up.
> 
> Anybody ambitious enough to add a "line too long" indicator of some sort? :)
> 

Good luck.  But the symbols are there.  Just use left/right arrow keys
to scroll the display left/right and you can see them.  Now if you just
had that indicator to tell you that you Need to scroll to see more text...

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
