Return-Path: <linux-kernel-owner+w=401wt.eu-S934014AbZFQO3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbZFQO3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbZFQO2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:28:53 -0400
Received: from claw.goop.org ([74.207.240.146]:57653 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbZFQO2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:28:53 -0400
Message-ID: <4A38FD96.6090109@goop.org>
Date: Wed, 17 Jun 2009 07:28:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/16] x86/oprofile: add module parameter option to	force
 a core 2 cpu
References: <1245183355-25808-1-git-send-email-jeremy@goop.org> <1245183355-25808-2-git-send-email-jeremy@goop.org> <20090617105725.GS18016@erda.amd.com>
In-Reply-To: <20090617105725.GS18016@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/09 03:57, Robert Richter wrote:
> On 16.06.09 13:15:40, Jeremy Fitzhardinge wrote:
>    
>> From: Robert Richter<robert.richter@amd.com>
>>
>> The current userland does not yet fully support all cpu types
>> implemented in the kernel. With the module parameter:
>>
>>   oprofile.cpu_type=core_2
>>
>> the kernel reports a core_2 cpu to the userland on an Intel system and
>> thus makes oprofile usable with current distros.
>>
>> Cc: Linus Torvalds<torvalds@linux-foundation.org>
>> Cc: Andi Kleen<ak@linux.intel.com>
>> Signed-off-by: Robert Richter<robert.richter@amd.com>
>> ---
>>   Documentation/kernel-parameters.txt |    3 ++-
>>   arch/x86/oprofile/nmi_int.c         |   17 ++++++++++++++---
>>   2 files changed, 16 insertions(+), 4 deletions(-)
>>      
>
> Jeremy,
>
> I dropped this patch. See this thread:
>
>   http://lkml.org/lkml/2009/5/6/234
>
> Does your patch series depends on this?
>    

Confused.  I haven't done anything with oprofile or nmi lately.  I don't 
recognize the patch you're quoting.

     J
