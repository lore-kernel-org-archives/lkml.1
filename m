Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXIZJSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXIZJSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXIZJSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:18:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:59610 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbXIZJSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:18:45 -0400
Message-ID: <46FA23DF.9000409@qumranet.com>
Date: Wed, 26 Sep 2007 11:18:23 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] 2.6.23-rc8-mm1: drivers/kvm/ioapic.o build failure
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>	<200709252256.23478.m.kozlowski@tuxland.pl>	<46FA1F99.8080701@qumranet.com> <20070926021424.37e34b4c.akpm@linux-foundation.org>
In-Reply-To: <20070926021424.37e34b4c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 26 Sep 2007 11:00:09 +0200 Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> Mariusz Kozlowski wrote:
>>     
>>> Hello,
>>>
>>> 	Similar (the same?) as in 2.6.23-rc6-mm1?
>>>
>>> http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg208812.html
>>> 	
>>>   CC [M]  drivers/kvm/ioapic.o
>>> drivers/kvm/ioapic.c: In function 'ioapic_deliver':
>>> drivers/kvm/ioapic.c:208: error: 'dest_LowestPrio' undeclared (first use in this function)
>>> drivers/kvm/ioapic.c:208: error: (Each undeclared identifier is reported only once
>>> drivers/kvm/ioapic.c:208: error: for each function it appears in.)
>>> drivers/kvm/ioapic.c:219: error: 'dest_Fixed' undeclared (first use in this function)
>>> make[2]: *** [drivers/kvm/ioapic.o] Error 1
>>> make[1]: *** [drivers/kvm] Error 2
>>> make: *** [drivers] Error 2
>>>
>>>   
>>>       
>> We now include asm/io_apic.h like we should.  Has that file changed in -mm?
>>
>>     
>
> CONFIG_X86_IO_APIC isn't set.
>   

Why should that matter?  we're just pulling that file for the definitions.


I'll try to compile without it here and see how it breaks.

-- 
error compiling committee.c: too many arguments to function

