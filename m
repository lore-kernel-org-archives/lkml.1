Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYGKUp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYGKUp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYGKUpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:45:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbYGKUpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:45:45 -0400
Date: Fri, 11 Jul 2008 22:45:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080711204521.GA15689@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu> <20080710215617.GM1678@linux-os.sc.intel.com> <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu> <20080711203151.GU1678@linux-os.sc.intel.com> <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Setting APIC routing to physical flat
> Kernel panic - not syncing: Boot APIC ID in local APIC unexpected (0 vs 4)
> Pid: 1, comm: swapper Not tainted 2.6.26-rc9-tip-01763-g74f94b1-dirty #320
> 
> Call Trace:
>  [<ffffffff80a21505>] ? set_cpu_sibling_map+0x38c/0x3bd
>  [<ffffffff80245215>] ? read_xapic_id+0x25/0x3e
>  [<ffffffff80e5a2c3>] ? verify_local_APIC+0x139/0x1b9
>  [<ffffffff80245215>] ? read_xapic_id+0x25/0x3e
>  [<ffffffff80e589af>] ? native_smp_prepare_cpus+0x224/0x2e9
>  [<ffffffff80e4881a>] ? kernel_init+0x64/0x341
>  [<ffffffff8022a439>] ? child_rip+0xa/0x11
>  [<ffffffff80e487b6>] ? kernel_init+0x0/0x341
>  [<ffffffff8022a42f>] ? child_rip+0x0/0x11
> 
> 
> guess read_apic_id changing cuase some problem...

i got a build error sooner so i've taken it out of tip/master again.

	Ingo
