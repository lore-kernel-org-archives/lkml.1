Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbZGIDqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbZGIDqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZGIDqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:46:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbZGIDql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:46:41 -0400
Message-ID: <4A5567E9.5080403@zytor.com>
Date: Wed, 08 Jul 2009 20:45:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86,apic -- don't forget to disconnect BSP discrete
 	apic
References: <20090708200741.GI5301@lenovo> <4A55109C.7040506@zytor.com> <aa79d98a0907082004i616ff057ic8eea014f712064d@mail.gmail.com>
In-Reply-To: <aa79d98a0907082004i616ff057ic8eea014f712064d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> On 7/9/09, H. Peter Anvin <hpa@zytor.com> wrote:
>> Cyrill Gorcunov wrote:
>>> In case of discrete APIC cpu_has_apic could be not set.
>>> This leads to disconnect_bsp_APIC is not called where
>>> it should.
>> I thought we were going to turn on cpu_has_apic in this case?
>>
>> 	-hpa
>>
>>
> Yes, this is just a temporary fix. I'll remove this snippet as only
> cpu-has-apic patch will be ready (i need to re-check all ways and and
> i need some time for this. Hope will finish it at weekend). Dunno
> Peter. If there is no urgency -- lets mark that we have this temporary
> workaround in lklm and if we get kind of bugreport we could apply the
> patch shortly :)


Since discrete-APIC systems are so old and rare I think it can wait for
the proper fix, however, as you said, if there are unexpected problems
we can reconsider.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

