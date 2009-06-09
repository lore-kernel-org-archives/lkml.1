Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZFIWuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZFIWuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZFIWt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:49:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42018 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZFIWt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:49:56 -0400
Date: Tue, 9 Jun 2009 23:48:58 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090609224858.GA18252@srcf.ucam.org>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu> <4A2E7B40.4070608@zytor.com> <alpine.LFD.2.01.0906091103080.6847@localhost.localdomain> <alpine.LFD.2.01.0906091106470.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906091106470.6847@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 11:07:41AM -0700, Linus Torvalds wrote:

> Side note: intel is to blame too. I think several Atom versions were 
> shipped with 64-bit mode disabled. So even "modern" CPU's are sometimes 
> artifically crippled to just 32-bit mode.

And some people still want to run dosemu so they can drive their 
godforsaken 80s era PIO driven data analyzer. It'd be nice to think that 
nobody used vm86, but they always seem to pop out of the woodwork 
whenever someone suggests 64-bit kernels by default.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
