Return-Path: <linux-kernel-owner+w=401wt.eu-S933765AbXGUAKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbXGUAKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXGUAKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:10:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbXGUAKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:10:30 -0400
Message-ID: <46A14D0C.7090007@zytor.com>
Date: Fri, 20 Jul 2007 17:02:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
References: <1184970779.4012.38.camel@chaos>	<46A1396F.4090204@garzik.org> <20070721005512.3db5fd77@the-village.bc.nu>
In-Reply-To: <20070721005512.3db5fd77@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 20 Jul 2007 18:38:39 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> I agree with Andi...  it's quite nice to be able to leave some arch/i386 
>> stuff, and not carry it over to arch/x86-64.
> 
> Its easy enough to push that stuff into arch/x86/legacy and have one
> subdirectory of stuff to pull in for ancient systems.

The other thing is that "legacy" in this context is fungible.  No IOMMU
was legacy until the Intel x86-64 chips came out, and I can promise you
that some legacy code will be necessary once we start seeing VIA and
others come out with embedded x86-64.

On the other hand, it's pretty bloody safe to assume that we'll never
see an x86-64 chip without CPUID, CMOV, FXSAVE, SSE-2, CMPXCHG, etc.

	-hpa
