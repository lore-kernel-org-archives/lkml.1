Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258Ab0AKXIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0AKXIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211Ab0AKXIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:08:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0AKXIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:08:24 -0500
Message-ID: <4B4BAF2B.5020406@zytor.com>
Date: Mon, 11 Jan 2010 15:07:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead
 of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>	<4B47E7A9.6090904@zytor.com>	<1263250418.2859.681.camel@sbs-t61.sc.intel.com> <m1zl4k8cy7.fsf@fess.ebiederm.org>
In-Reply-To: <m1zl4k8cy7.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 03:00 PM, Eric W. Biederman wrote:
>>
>> In irqinit.c, we statically pre-assign the per-cpu vector to irq
>> mappings (vector_irq) for all the legacy IRQ vectors. Similarly irq_cfg
>> is statically initialized for legacy IRQ's in io_apic.c. So we won't be
>> able to use this space for anything else.
> 
> Last I looked when we switched legacy irqs irqs from pic mode to io_apic mode
> we continue to use the same vector.
> 
> Which means we should not be wasting those vectors and that it is dangerous
> to play lowest priority irq games in that range.
> 

This statement made no sense to me?

	-hpa

