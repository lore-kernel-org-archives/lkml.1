Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbXJXGFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbXJXGFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXJXGFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:05:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36070 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbXJXGFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:05:35 -0400
Message-ID: <471EE0A9.2040008@garzik.org>
Date: Wed, 24 Oct 2007 02:05:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCH 2/12] X86: fix nvidia HPET warning
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223635.24CE01F81A1@havoc.gtf.org> <471EC48E.2080506@goop.org>
In-Reply-To: <471EC48E.2080506@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jeff Garzik wrote:
>> arch/x86/kernel/early-quirks.c:40: warning: ‘nvidia_hpet_check’ defined but not used
>>
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>> ---
>>
>> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
>> index dc34acb..639e632 100644
>> --- a/arch/x86/kernel/early-quirks.c
>> +++ b/arch/x86/kernel/early-quirks.c
>> @@ -35,12 +35,14 @@ static void __init via_bugs(void)
>>  }
>>  
>>  #ifdef CONFIG_ACPI
>> +#ifdef CONFIG_X86_IO_APIC
>>   
> 
> Why not #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)?  Saves
> a line and a layer of #if(def).

quite agreed, but I was merely duplicating (with precision :)) the 
ifdef-ery used in the caller

	Jeff



