Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYGLErj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYGLErj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 00:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYGLErb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 00:47:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43797 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYGLEra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 00:47:30 -0400
Date: Sat, 12 Jul 2008 06:47:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: today's linux-next fails to boot
Message-ID: <20080712044707.GA6675@elte.hu>
References: <4877400B.1000400@gmail.com> <20080711190749.GB21758@elte.hu> <200807112306.39455.rjw@sisk.pl> <200807120250.16459.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807120250.16459.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Hi Ingo,
> 
> On Friday, 11 of July 2008, Rafael J. Wysocki wrote:
> > On Friday, 11 of July 2008, Ingo Molnar wrote:
> > > 
> > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> [--snip--]
> > 
> > Well, it turns out that linux-next from today doesn't boot on my box too
> > (64-bit) and I don't see anything obviously suspicious.  Bisection time.
> 
> I have identified the source of the breakage on my box, but I don't 
> really think it's the same problem that Edwin is observing.
> 
> Namely, it turns out that some code in arch/x86/kernel/acpi/boot.c, as 
> in today's linux-next, doesn't really make sense, because we have two 
> conflicting DMA-based quirks in there for the same set of boxes (HP 
> nx6325 and nx6125) and one of them actually breaks my box.
> 
> I have reported that already, but it probably got lost somewhere.
> 
> Below is a patch that fixes things for me, on top of today's 
> linux-next. Please apply.

thanks Rafael, i have applied your fix to tip/x86/core and to 
auto-x86-next as well.

what happened is a case of too many fixes for the same problem :-/

	Ingo
