Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbZGDAQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbZGDAQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 20:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZGDAQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 20:16:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60997 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZGDAQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 20:16:24 -0400
Message-ID: <4A4E9E34.2030103@zytor.com>
Date: Fri, 03 Jul 2009 17:11:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org> <200907031602.20948.lkml@morethan.org> <4A4E8741.7030806@zytor.com> <200907031905.55258.lkml@morethan.org>
In-Reply-To: <200907031905.55258.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> On Fri July 3 2009, H. Peter Anvin wrote:
>> Michael S. Zick wrote:
>>>> The CPUID flags, in particular the pse flag.
>>>>
>>> I haven't touch anything that would have changed that -
>>> so this should be representative (the *&^*% datasheet says yes to pse also)
>>>
>> Actually, come to think of it, we don't generate PSE page tables
>> initially -- we only later go in and reclaim the page tables if we
>> switch to PSE (and $DEITY knows if we're doing it correctly...)
>>
> 
> I am of that age range where senility has to be considered, but not this time:
> 
> "Via C7-M Datasheet", May 2008 (supposed to be most recent) -
> 
> page 22 - section 2.3.7 - Table 2-14 "CR4 Bits"
> "<5> PAE: Enables address extensions; C7-M:<r>" 
> <quote>An "r" means that this bit is reserved.  It appears as a 0 when read,
> and a GP exception is signaled if an attemp is made to write a 1 to this bit.</quote>
> 
> Same document -
> page 16 - section 2.3.2 - Table 2-3 "CPUID Feature Flag Values (EAX=1)"
> <EDX:6> PAE: Physical address extensions; C7:<1>

Especially since I was talking about PSE and not PAE.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

