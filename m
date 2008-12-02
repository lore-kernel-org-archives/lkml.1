Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYLBXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYLBXGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYLBXGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:06:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:57166 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYLBXGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:06:15 -0500
Cc: Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org
Message-Id: <EAAB7B1A-49DC-4D61-A76F-F87C777566D8@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1228253423.7356.195.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH][for 2.6.28] powerpc: Use physical cpu id when setting the processor affinity
Date: Tue, 2 Dec 2008 17:05:25 -0600
References: <1228246621-25622-1-git-send-email-galak@kernel.crashing.org> <1228253423.7356.195.camel@pasglop>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 2, 2008, at 3:30 PM, Benjamin Herrenschmidt wrote:

> On Tue, 2008-12-02 at 13:37 -0600, Kumar Gala wrote:
>> In the CONFIG_SMP case the irq_choose_cpu() code was returning back
>> a logical cpu id not the physical id.  We were writing that directly
>> into the HW register.
>>
>> We need to be calling get_hard_smp_processor_id() so irq_choose_cpu()
>> always returns a physical cpu id.
>
> That will probably do for now but if we ever move that routine to
> generic code, I'd rather have the caller do the conversion.

Fair.. I felt at this point matching what the !CONFIG_SMP case of  
irq_choose_cpu() is doing was the best choice.

- k
