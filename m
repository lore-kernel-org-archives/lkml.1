Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbZKGQ5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbZKGQ5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 11:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZKGQ5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 11:57:07 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60142 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZKGQ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 11:57:05 -0500
Message-ID: <4AF5A6E2.5040306@in.ibm.com>
Date: Sat, 07 Nov 2009 22:27:06 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: linux-next: Tree for November 5
References: <20091105190426.c9cadada.sfr@canb.auug.org.au> <200911050931.04838.bjorn.helgaas@hp.com> <200911051017.12135.bjorn.helgaas@hp.com> <200911060856.09405.bjorn.helgaas@hp.com>
In-Reply-To: <200911060856.09405.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Thursday 05 November 2009 10:17:11 am Bjorn Helgaas wrote:
>   
>> On Thursday 05 November 2009 09:31:04 am Bjorn Helgaas wrote:
>>     
>>> On Thursday 05 November 2009 03:38:27 am Sachin Sant wrote:
>>>       
>>>> Today's next tree fails to build on i386 with
>>>>
>>>> arch/x86/pci/built-in.o: In function `align_resource':
>>>> arch/x86/pci/acpi.c:82: undefined reference to `__udivdi3'
>>>>
>>>> The code in question was added by commit
>>>> 03db42adfeeabe856dbb6894dd3aaff55838330a.
>>>>         
>>> I'll look into this.  I did build and test a 32-bit x86 kernel, but
>>> I built it on an x86_64 box using "linux32 make ...", which looks like
>>> it used gcc 4.3.2.
>>>       
>> Can you try the patch below, please?
>>     
>
> Sachin, can you please try this patch and report whether it
> fixes the undefined reference?  I hate to have linux-next
> broken longer than necessary.
>   
Sorry was away from office for a day. Yes the patch
fixed the build break for me. 

Thanks for the patch.

Regards
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

