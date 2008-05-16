Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYEPNEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYEPNEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYEPNEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:04:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51536 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbYEPNEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:04:36 -0400
Date: Fri, 16 May 2008 15:04:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] x86: Move es7000_plat out of mpparse.c
Message-ID: <20080516130422.GA24607@elte.hu>
References: <20080514150251.24443.5516.stgit@thinkpad> <20080516124319.GB16520@elte.hu> <20080516130342.GA22993@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516130342.GA22993@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the build failure is:

arch/x86/kernel/built-in.o: In function `init_apic_mappings':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `init_apic_mappings':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
: undefined reference to `phys_cpu_present_map'
arch/x86/kernel/built-in.o: In function `setup_local_APIC':
: undefined reference to `phys_cpu_present_map'
arch/x86/kernel/built-in.o: In function `generic_processor_info':
: undefined reference to `phys_cpu_present_map'
arch/x86/kernel/built-in.o: In function `generic_processor_info':
: undefined reference to `num_processors'
arch/x86/kernel/built-in.o: In function `generic_processor_info':
: undefined reference to `num_processors'
arch/x86/mach-visws/built-in.o: In function `find_smp_config':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/mach-visws/built-in.o: In function `find_smp_config':
: undefined reference to `phys_cpu_present_map'

