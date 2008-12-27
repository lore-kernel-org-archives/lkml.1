Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYL0Vmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYL0Vmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 16:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYL0Vmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 16:42:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52248 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbYL0Vmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 16:42:31 -0500
Message-ID: <4956A142.6010207@redhat.com>
Date: Sat, 27 Dec 2008 23:42:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, jeremy@goop.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] Remove interrupt stack table usage from x86_64	kernel
 (v2)
References: <1230301344-570-1-git-send-email-avi@redhat.com> <20081226143517.GA25668@elte.hu> <20081226143836.GA3610@elte.hu>
In-Reply-To: <20081226143836.GA3610@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> They have the following commit IDs, and they are also in tip/master:
>>
>>  921e521: x86: move NMI back to interrupt stack
>>  36ef6c9: x86: make interrupt stack switching atomic
>>  dd64891: x86: consolidate irq stack switching to a single macro
>>  955a368: x86: drop the use of the tss interrupt stack table (IST)
>>
>> I also started testing them in tip-qa.
>>     
>
> testing failed quickly, the attached config crashes. I've pushed out the 
> bad kernel to the tip/tmp.master.bad branch:
>
>  fe3aac9: Merge branch 'x86/irq'
>
> (no crashlog available - all i know that the box crashed and rebooted, 
> when booted with the bzImage built out of the attached config.)
>   

I managed to reproduce this (after several hundred million interrupts 
and several dozen million NMIs - do you run anything special on your tests?)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

