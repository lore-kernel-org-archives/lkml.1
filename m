Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbYLYJUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbYLYJUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 04:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYLYJU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 04:20:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58273 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYLYJU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 04:20:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] Performance Counters for Linux, v5
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20081225080422.GA9430@elte.hu>
References: <20081225162242.50E8.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225080422.GA9430@elte.hu>
Message-Id: <20081225175131.50EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Dec 2008 18:20:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi Ingo,
> > 
> > Currently, -tip tree can't build on my ia64 box.
> > because..
> > 
> > >  create mode 100644 Documentation/perf-counters.txt
> > >  delete mode 100644 arch/x86/include/asm/intel_arch_perfmon.h
> > >  create mode 100644 arch/x86/include/asm/perf_counter.h
> > >  create mode 100644 arch/x86/kernel/cpu/perf_counter.c
> > >  rename arch/x86/kernel/{signal_32.c => signal.c} (74%)
> > >  delete mode 100644 arch/x86/kernel/signal_64.c
> > >  create mode 100644 include/linux/perf_counter.h
> > >  create mode 100644 kernel/perf_counter.c
> > 
> > 
> > Only x86 has <asm/perf_counter.h>.
> 
> thanks - the fix below resolves it, right?
> 
> 	Ingo

ok.
Now, my box boot successfully.

	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
	Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

thanks.


