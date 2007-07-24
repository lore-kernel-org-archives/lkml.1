Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXGXPGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXGXPGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXGXPG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:06:29 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:42378 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXGXPG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:06:28 -0400
Message-ID: <46A61163.3000701@aitel.hist.no>
Date: Tue, 24 Jul 2007 16:49:07 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Uwe Hermann <uwe@hermann-uwe.de>, Matt Mackall <mpm@selenic.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org> <20070718201043.GF3898@one.firstfloor.org> <20070718204102.GM11115@waste.org> <20070720072730.GN3700@greenwood> <20070720073509.GA19833@one.firstfloor.org>
In-Reply-To: <20070720073509.GA19833@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Some people are putting Linux kernels in the "BIOS" (i.e. ROM chip) when
>> using LinuxBIOS (www.linuxbios.org). It _does_ make a lot of difference
>> there how big the kernel is. At the moment you can't do that with
>> anything smaller than a 1 MB chip. But if people could use 512 KB chips
>> because the kernel is small enough that would sure be a great thing.
>>     
>
> I'm sure it would be possibel to save a lot of text size. But I don't
> think removing the relatively small CPUID code is the right way.
> That is just a big maintenance issue for little gain.
>   
Well - anyone compiling linux for BIOS usage is targetting
a single machine.  So an ability to target a single machine is useful,
i.e. run the CPUID at compile-time, put the answer in a constant/macro,
let the optimizer prune the alternatives. :-)

Helge Hafting
