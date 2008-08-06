Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYHFMC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYHFMC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYHFMCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:02:19 -0400
Received: from mail.tmr.com ([64.65.253.246]:49293 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbYHFMCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:02:18 -0400
Message-ID: <4899951A.1040704@tmr.com>
Date: Wed, 06 Aug 2008 08:12:10 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: David Wilson <mcs6502@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: What is the best way to identify a new x86 processor that does
 not implement the CPUID instruction?
References: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com>
In-Reply-To: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wilson wrote:
> I recently bought a Norhtec MicroClient JrSX which uses the Vortex86sx
> System on Chip processor (see http://vortex86sx.com/ for more
> details). This is identified as a Cyrix 486SLC by the Linux kernel due
> to the lack of a CPUID instruction. While this may be seen as a
> cosmetic defect, if the kernel can identify the processor correctly it
> could, for example, use the clock divisor code provided by the
> manufacturer to slow down and speed up the CPU when required.
> 
> The question is: how to differentiate this chip from the Cyrix part?
> The freely available "brief data sheet" does not provide much detail.
> 
> I have thought of a couple of schemes but am not really keen on either:
> 
> 1) Clock speed - the SoC runs at 300+ MHz while the Cyrix part is < 100 MHz
> 2) Look at the PCI VID/PID for the north bridge as this is part of the CPU die.
> 
> Does anyone have any suggestions? Thanks.

Your (2) sounds reasonable.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
