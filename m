Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbYDVPJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbYDVPJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbYDVPJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:09:16 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41794 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932940AbYDVPJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:09:15 -0400
Message-ID: <480DFF98.7030203@sgi.com>
Date: Tue, 22 Apr 2008 08:09:12 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: cleanup early per cpu variables/accesses	v3-folded
References: <20080422013415.955439000@polaris-admin.engr.sgi.com> <20080422013416.483730000@polaris-admin.engr.sgi.com> <20080422135944.GA24966@elte.hu>
In-Reply-To: <20080422135944.GA24966@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>   * Introduce a new PER_CPU macro called "EARLY_PER_CPU".  This is
>>     used by some per_cpu variables that are initialized and accessed
>>     before there are per_cpu areas allocated.
> 
> build fails with:
> 
> arch/x86/kernel/built-in.o: In function `flat_apic_id_registered':
> genapic_flat_64.c:(.text+0x13e1d): undefined reference to `phys_cpu_present_map'
> genapic_flat_64.c:(.text+0x13e24): undefined reference to `phys_cpu_present_map'
> arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> : undefined reference to `phys_cpu_present_map'
> [...]
> 
> with this config:
> 
>   http://redhat.com/~mingo/misc/config-Tue_Apr_22_15_40_10_CEST_2008.bad
> 
> 	Ingo

Ok, thanks, I'll check it out.

Mike
