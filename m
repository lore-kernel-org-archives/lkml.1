Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbZCSRqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbZCSRqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZCSRp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:45:59 -0400
Received: from shakaweb.org ([85.25.54.21]:59567 "EHLO shakaweb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbZCSRp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:45:58 -0400
Message-ID: <49C28494.5030403@shakaweb.org>
Date: Thu, 19 Mar 2009 18:44:52 +0100
From: Christopher Schramm <debian@shakaweb.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <49C1FE7D.9070605@shakaweb.org> <20090319100122.GA30358@elte.hu> <49C25712.9010509@shakaweb.org> <20090319154955.GA21034@elte.hu>
In-Reply-To: <20090319154955.GA21034@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 94.216.219.212
X-SA-Exim-Mail-From: debian@shakaweb.org
Subject: Re: APIC problem report
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shakaweb.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar schrieb:
> By the looks of it, chances are that various APIC fixes and 
> robustization patches might have fixed your problem:
> 
>  691874f: x86: I/O APIC: timer through 8259A second-chance
>  03be750: x86: I/O APIC: keep the timer IRQ masked during set-up
>  24742ec: x86: I/O APIC: unmask the second-chance timer interrupt
>  d11d579: x86: I/O APIC: AEOI timer acknowledgement clean-ups
> 
> These first showed up in v2.6.27. Which would match your reported 
> symptoms of v2.6.26 failig and 2.6.28 working.

Yes, you're right. Looking at the detailed kernel messages, the "8259A 
second-chance" seems to do the trick. So it's already tackled. :-)

Christopher
