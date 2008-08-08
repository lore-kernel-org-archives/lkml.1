Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYHHLAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYHHLAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYHHLAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:00:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43417 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYHHLAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:00:38 -0400
To: "David Wilson" <mcs6502@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What is the best way to identify a new x86 processor that does not implement the CPUID instruction?
From: Andi Kleen <andi@firstfloor.org>
References: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com>
Date: Fri, 08 Aug 2008 13:00:35 +0200
In-Reply-To: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com> (David Wilson's message of "Tue, 5 Aug 2008 17:08:35 +1000")
Message-ID: <87tzdv4vqk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Wilson" <mcs6502@gmail.com> writes:

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

I would suggest asking the CPU vendor. Surely they have some method.
Then submit a patch to detect that CPU based on that method.

-Andi
