Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZFHJJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZFHJJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZFHJJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:09:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:41232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZFHJJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:09:18 -0400
Subject: Re: [GIT-PULL -tip] x86: xpu_debug patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090608083947.GC6372@elte.hu>
References: <1244447882.6943.2.camel@ht.satnam>
	 <20090608083947.GC6372@elte.hu>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 14:40:25 +0530
Message-Id: <1244452225.6943.17.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 10:39 +0200, Ingo Molnar wrote:

> Those look like good fixes - but before we start extending on all 
> this - a more general question has to be raised: do people find this 
> useful?
> 
> I had a look at the current /debug/x86/cpu*/ layout, and a fair 
> portion of it looks completely meaningless at the moment: there's a 
> lot of hexa fields with absolutely zero symbolic information about 
> what the fields actually mean.
> 

I am planning to send hex to MSR_hex in next series along with :-
1. IO_hex : (IO registers)
2. PCI_hex : (PCI defined configuration space)
3. APIC_hex : (APIC memory based registers)
4. CPUID_hex : (CPUID Instruction registers)
5. MSR_hex : MSRs

Which will give almost full information of CPU state and will be more
useful to users and developers.

> There's a few good exceptions like /debug/x86/cpu/cpu0/apic/apic or 
> /debug/x86/cpu/cpu0/cr/cr, although even those should probably be 
> renamed to:
> 
>   /debug/x86/cpu/cpu0/apic/state
>   /debug/x86/cpu/cpu0/cr/state
> 
> as 'apic/apic' and 'cr/cr' is meaningless.
> 

OK, I will fix it.

> Or better yet, why isnt there a directory structure to known values:
> 
>   /debug/x86/cpu/cpu0/apic/LVTERR/value
> 
> ?

Yes. I will also support it as I said above.

I am working on it, can you please pull this series, because these
patches was pending from more than one month. Once this patches will be
applied. I can work on next phase.

Thanks,
--
JSR

