Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZFIXCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZFIXCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZFIXCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:02:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZFIXCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:02:06 -0400
Message-ID: <4A2EE80D.2010708@zytor.com>
Date: Tue, 09 Jun 2009 15:54:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu> <4A2E7B40.4070608@zytor.com> <alpine.LFD.2.01.0906091103080.6847@localhost.localdomain> <alpine.LFD.2.01.0906091106470.6847@localhost.localdomain> <20090609224858.GA18252@srcf.ucam.org>
In-Reply-To: <20090609224858.GA18252@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Jun 09, 2009 at 11:07:41AM -0700, Linus Torvalds wrote:
> 
>> Side note: intel is to blame too. I think several Atom versions were 
>> shipped with 64-bit mode disabled. So even "modern" CPU's are sometimes 
>> artifically crippled to just 32-bit mode.
> 
> And some people still want to run dosemu so they can drive their 
> godforsaken 80s era PIO driven data analyzer. It'd be nice to think that 
> nobody used vm86, but they always seem to pop out of the woodwork 
> whenever someone suggests 64-bit kernels by default.
> 

There is both KVM and Qemu as alternatives, though.  The godforsaken
80s-era PIO driven data analyzer will run fine in Qemu even on
non-HVM-capable hardware if it's 64-bit capable.  Most of the time it'll
spend sitting in PIO no matter what you do.

	-hpa

