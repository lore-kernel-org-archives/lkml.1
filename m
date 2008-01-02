Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYABUnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYABUnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYABUne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:43:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbYABUnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:43:33 -0500
Date: Wed, 2 Jan 2008 21:43:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [patch] x86 compat_binfmt_elf, Makefile fixes (was: Re:
	2.6.24-rc6-mm1)
Message-ID: <20080102204300.GA16867@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <200712232344.39302.rjw@sisk.pl> <20080102200511.GA3722@elte.hu> <200801022132.30994.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801022132.30994.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Wednesday, 2 of January 2008, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > Try to delete your fs/ directory in your output dir. Then I expect 
> > > > the same bug to surface again.
> > > 
> > > It does surface indeed.
> > 
> > could you try the patch from Sam below - does it fix the problem? 
> 
> Well, with this patch applied the compilation reliably fails with:
> 
> No rule to make target `arch/x86/ia32/ia32_binfmt.o', needed by 
> `arch/x86/ia32/built-in.o'.
> 
> [Do you want the .config, btw?]

i think i'll wait for Roland and Sam to sort it out.

	Ingo
