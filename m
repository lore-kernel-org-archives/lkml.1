Return-Path: <linux-kernel-owner+w=401wt.eu-S1763551AbYENPVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763551AbYENPVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYENPVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:21:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49857 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYENPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:21:13 -0400
Message-ID: <482B0363.6080700@firstfloor.org>
Date: Wed, 14 May 2008 17:21:07 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>, caglar@pardus.org.tr,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
References: <20080513204206.GA17781@damson.getinternet.no>	<873aol9b73.fsf@basil.nowhere.org>	<19f34abd0805131409w2914fbedgb608c7b87c234e2e@mail.gmail.com>	<482A05F3.7020408@firstfloor.org>	<20080513210217.59a7ca65@infradead.org>	<482A8D7D.7000208@firstfloor.org> <20080514065558.41071ca8@infradead.org>
In-Reply-To: <20080514065558.41071ca8@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 14 May 2008 08:58:05 +0200
>>> If the bios says mwait is usable, we need to use it with the values
>>> IT gives us.
>> At least to my knowledge the ACPI FADT just says what C states are
>> available, not if they are implemented with MWAIT or using IO ports.
> 
> _CST does; which is what the mwait C-state selection code uses.
> 
> (and we've seen quirky systems where C1 mwait didn't work, SMM did
> something wrong or something,

What do you mean with didn't work? And they did not report it in CPUID?
And are they wide spread? I haven't heard of any such problems before.

Even the P4 problem is not really that serious btw.

 because the other OS doesn't seem to use
> it for that, so making it the default is not really an option)

But it has been default for practically forever.   It is strange
if you declare Linux default behavior for years suddenly as "not really
an option"

I think it's a sane default. And MWAIT is a valuable optimization.

I don't think we should stop sanely architected interfaces on the first
BIOS quirk someone reports. I'm sure for nearly every feature there's
some broken BIOS out there that gets it wrong somehow. If we did this in
general soon we couldn't use anything.

-Andi

