Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZBQT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZBQT2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZBQT2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:28:00 -0500
Received: from gw.goop.org ([64.81.55.164]:33157 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbZBQT2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:28:00 -0500
Message-ID: <499B0FBA.4010006@goop.org>
Date: Tue, 17 Feb 2009 11:27:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: (spurious?) lockdep warning on Xen boot
References: <4999ED6A.8000803@goop.org> <1234868345.4744.71.camel@laptop>
In-Reply-To: <1234868345.4744.71.camel@laptop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Right, so you are saying you started out with IRQs enabled, and the
> above local_irq_restore() would simply be the first irq-op to re-enable
> it and goes splat.
>   
Yep.

> In which case your disabled from beginning 'fix' looks like the right
> thing to do.
>   

OK.

>> Or perhaps the second warning is real; in which case, where does the 
>> problem lie? (I guess another case of being bitten by calling 
>> __purge_vmap_area_lazy from interrupt context.)
>>     
>
> Looks like a real problem, and yes your suggestion makes sense.
>   

OK.

Thanks,
    J
