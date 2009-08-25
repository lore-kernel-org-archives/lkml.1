Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZHYN5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZHYN5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZHYN5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:57:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53846 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbZHYN47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:56:59 -0400
Date: Tue, 25 Aug 2009 15:56:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix build with older binutils and
	consolidate linker script
Message-ID: <20090825135651.GA22484@elte.hu>
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com> <tip-ddc98b38b6320d5de2e3167673a06ec1a48e9d0e@git.kernel.org> <20090825075029.GA857@elte.hu> <4A9408FC02000078000119B1@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9408FC02000078000119B1@vpn.id2.novell.com>
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

> >>> Ingo Molnar <mingo@elte.hu> 25.08.09 09:50 >>>
> >
> >* tip-bot for Jan Beulich <JBeulich@novell.com> wrote:
> >
> >> Commit-ID:  ddc98b38b6320d5de2e3167673a06ec1a48e9d0e
> >> Gitweb:     http://git.kernel.org/tip/ddc98b38b6320d5de2e3167673a06ec1a48e9d0e 
> >> Author:     Jan Beulich <JBeulich@novell.com>
> >> AuthorDate: Tue, 18 Aug 2009 16:51:27 +0100
> >> Committer:  H. Peter Anvin <hpa@zytor.com>
> >> CommitDate: Mon, 24 Aug 2009 15:51:35 -0700
> >> 
> >> x86: Fix build with older binutils and consolidate linker script
> >
> >this breaks the build with newer binutils:
> 
> With the updated patch just submitted I made sure UP and SMP 
> builds work as well as building with old and current binutils. 

Thanks, applied.

> Sorry for having forgotten to do so before submitting the first 
> time (I know I had intended to).

This happens. I'm still unsure whether we can do it in .31.0 or need 
to delay it to .31.1 via a -stable backport tag. One more problem 
with it and i think we'll need to delay it - it's just too large and 
changes too many aspects of the linker script.

Would it be possible to split it into two pieces: 'minimal fix' and 
'clean up' portions?

	Ingo
