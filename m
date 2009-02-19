Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZBSSM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZBSSM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZBSSMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:12:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42631 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZBSSMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:12:14 -0500
Date: Thu, 19 Feb 2009 19:12:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: more untangling
Message-ID: <20090219181202.GA12999@elte.hu>
References: <4995CCB1.9070404@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4995CCB1.9070404@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I've done the asm _types.h and page->pgtable moves.  One 
> hiccup is kernel/head_64.S uses pgd_index(), which is defined 
> as an asm-compatible macro in pgtable.h.  Its a bit warty 
> because it also needs pud_index(), which it defines locally 
> (which is an inline in pgtable.h).  Need to think about that 
> one...
>
>    J
>
> The following changes since commit beb6943d8df7ce9278282101af4e0f6f7b648451:
>  Ingo Molnar (1):
>        x86 headers: protect page_32.h via __ASSEMBLY__
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/untangle2
>
> Jeremy Fitzhardinge (2):
>      x86: use _types.h headers in asm where available
>      x86: move more pagetable-related definitions into pgtable*.h

Pulled into tip:x86/headers, thanks Jeremy!

	Ingo
