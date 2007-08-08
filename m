Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbXHHS02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbXHHS02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbXHHS0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:26:20 -0400
Received: from mail.tpi.com ([198.107.51.143]:2806 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbXHHS0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:26:20 -0400
Message-ID: <46BA0A9D.1040405@canonical.com>
Date: Wed, 08 Aug 2007 12:25:33 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Cal Peake <cp@absolutedigital.net>
CC: Andi Kleen <ak@suse.de>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drop unneeded variable in amd_apic_timer_broken
References: <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net> <20070808000631.GB7353@one.firstfloor.org> <Pine.LNX.4.64.0708072030440.28681@lancer.cnet.absolutedigital.net> <200708081636.20223.ak@suse.de> <Pine.LNX.4.64.0708081146120.25865@lancer.cnet.absolutedigital.net>
In-Reply-To: <Pine.LNX.4.64.0708081146120.25865@lancer.cnet.absolutedigital.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cal Peake wrote:
> On Wed, 8 Aug 2007, Andi Kleen wrote:
> 
>> Can you please test if this patch works?
> 
> Yep, seems to do the trick. Thanks!
> 
>> BTW I checked with AMD and they seem to think it's just a buggy BIOS.
> 
> Nod. Atleast we can work around it.
> 
>> Use global flag to disable broken local apic timer on AMD CPUs.
>>
>> The Averatec 2370 laptop BIOS seems to program the ENABLE_C1E
> 
> s~2370~2370/2371~ to be completely accurate ;)
> 
>> MSR inconsistently between cores. This confuses the lapic
>> use heuristics wants to know if C1E is enabled anywhere.
>>
>> Use a global flag instead of a per cpu flag to handle this.
>> If any CPU has C1E enabled disabled lapic use.
>>
>> Thanks to Cal Peake for debugging.
>> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Acked-by: Cal Peake <cp@absolutedigital.net>
> 

This patch also solves the boot problem on a Dell E1501. I started the
thread "ACPI Regression on Dell E1501" regarding this issue on June 21,
2007.

Acked-by: Tim Gardner <tim.gardner@ubuntu.com>

-- 
Tim Gardner tim.gardner@ubuntu.com
