Return-Path: <linux-kernel-owner+w=401wt.eu-S1764379AbXLNJxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764379AbXLNJxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbXLNJxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:53:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbXLNJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:53:44 -0500
Date: Fri, 14 Dec 2007 01:53:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Arun Thomas" <arun.thomas@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
Message-Id: <20071214015315.09829a99.akpm@linux-foundation.org>
In-Reply-To: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 04:10:31 -0500 "Arun Thomas" <arun.thomas@gmail.com> wrote:

> My Dell Vostro desktop w/ an Intel E6850 dual-core 3GHz CPU has an 8+
> minute delay during boot. The machine seems to run fine after it
> boots. The problem occurs on the Ubuntu gutsy 2.6.22-14 kernel,
> 2.6.23.9, and 2.6.24-rc5. I have upgraded to the most recent Dell BIOS
> version (1.0.8). I am running an SMP kernel currently, but the problem
> presents itself in uniprocessor mode (nosmp) also. I'm running the
> machine in 32-bit mode w/hyperthreading configured.
> 
> Here are a few interesting things in the dmesg output for the
> 2.6.24-rc5 kernel (smp). The full dmesg is also included farther down.
> 
> [   20.101501] CPU: After generic identify, caps: bfebfbff 20100000
> 00000000 00000000 0000e3fd 00000000 00000001 00000000
> [   20.101505] monitor/mwait feature present.
> [   20.101506] using mwait in idle threads.
> [   20.101508] CPU: L1 I cache: 32K, L1 D cache: 32K
> [   20.101509] CPU: L2 cache: 4096K
> [   20.101511] CPU: Physical Processor ID: 0
> [   20.101511] CPU: Processor Core ID: 0
> [   20.101513] CPU: After all inits, caps: bfebfbff 20100000 00000000
> 00003940 0000e3fd 00000000 00000001 00000000
> [   20.101517] Compat vDSO mapped to ffffe000.
> [   20.101525] Checking 'hlt' instruction... OK.
> [   20.117651] SMP alternatives: switching to UP code
> [   20.118574] ACPI: Core revision 20070126
> [   20.175154] CPU0: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz stepping 0b
> [   20.175163] SMP alternatives: switching to SMP code
> [   20.175437] Booting processor 1/1 eip 3000
> [   20.185881] Initializing CPU#1
> [  527.926587] Calibrating delay using timer specific routine..
> 200566.59 BogoMIPS (lpj=401133185)
> [  527.926592] CPU: After generic identify, caps: bfebfbff 20100000
> 00000000 00000000 0000e3fd 00000000 00000001 00000000
> [  527.926595] monitor/mwait feature present.
> [  527.926596] CPU: L1 I cache: 32K, L1 D cache: 32K
> [  527.926597] CPU: L2 cache: 4096K
> [  527.926599] CPU: Physical Processor ID: 0

Silly question: is that delay actually observeable by a human,
or is it just a leap in the printk timestamping?
