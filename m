Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbXESM2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbXESM2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXESM2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:28:18 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:41186 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbXESM2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:28:18 -0400
In-Reply-To: <787b0d920705181845h355eed4fk2bf93323332a9d90@mail.gmail.com>
References: <787b0d920705172024g723412b4n8f82d3cd78e0f702@mail.gmail.com> <464DBDBA.3060801@ru.mvista.com> <787b0d920705181845h355eed4fk2bf93323332a9d90@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <fa84736ae121902d4bee24eb23ca1d0b@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: tglx@linutronix.de, "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Sat, 19 May 2007 14:28:14 +0200
To: "Albert Cahalan" <acahalan@gmail.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Unfortunately, FIT exists only on Book E CPUs and MPC74xx aren't Book 
>> E, IIUC.
>
> By the name "FIT" perhaps, but MPC74xx has essentially
> the same thing.

> Set MMCR0[TBEE], set MMCR0[PMXE], and choose a TBL bit via 
> MMCR0[TBSEL].

That's the performance monitor, which could very well be
in use already (for performance monitoring stuff, who
would have guessed).

> It's also possible to trigger on the CPU cycle counter, but this would
> cost one of the performance counters. MPC7400 has 4, later CPUs have 6
> or more, and I think xPC7x0 had only 2.

7xx has at least four as well.


Segher

