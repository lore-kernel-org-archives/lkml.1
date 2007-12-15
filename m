Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXLOGHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXLOGHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXLOGHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:07:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:42161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXLOGHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:07:35 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Arun Thomas" <arun.thomas@gmail.com>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
Date: Sat, 15 Dec 2007 01:07:20 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
In-Reply-To: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712150107.20400.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 04:10, Arun Thomas wrote:
> Hi,
> 
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

try CONFIG_HIGH_RES_TIMERS=n
try "hpet=disable"

-Len
