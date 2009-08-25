Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZHYOsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZHYOsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZHYOsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:48:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45212 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbZHYOs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:48:29 -0400
Date: Tue, 25 Aug 2009 16:48:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org, hpa@zytor.com
Subject: Re: [tip:x86/urgent] x86: Fix build with older
	binutilsandconsolidate linker script
Message-ID: <20090825144816.GA28026@elte.hu>
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com> <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org> <20090825075029.GA857@elte.hu> <4A9408FC02000078000119B1@vpn.id2.novell.com> <20090825135651.GA22484@elte.hu> <4A940AE502000078000119C5@vpn.id2.novell.com> <20090825141405.GA14879@elte.hu> <4A9412DE0200007800011A07@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9412DE0200007800011A07@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 25.08.09 16:14 >>>
> >
> >* Jan Beulich <JBeulich@novell.com> wrote:
> >
> >> >>> Ingo Molnar <mingo@elte.hu> 25.08.09 15:56 >>>
> >> >Would it be possible to split it into two pieces: 'minimal fix' and 
> >> >'clean up' portions?
> >> 
> >> Besides being cumbersome, that would make it even larger, so I'd 
> >> say that's not worth it.
> >
> >I mean the two patches yield the same end result. The first one 
> 
> I also understood it that way.
> 
> >(which is smaller, hopefully) gets committed to x86/urgent, the 
> >second one (the cleanups and other non-essentials) gets pushed 
> >upstream in .32.
> 
> The cleanup part really isn't much more than what I described with 
> "Once touching this code, also use the various data section helper 
> macros from include/asm-generic/vmlinux.lds.h.", and if the first 
> patch wouldn't use those macros, it would just grow and become 
> even less readable.

fair enough. Lets hope it all goes fine.

	Ingo
