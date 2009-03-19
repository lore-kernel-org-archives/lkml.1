Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZCSKus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZCSKus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZCSKui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:50:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42201 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZCSKuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:50:37 -0400
Date: Thu, 19 Mar 2009 11:50:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Microblaze linux support
Message-ID: <20090319105001.GC2579@elte.hu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <20090319072256.GA5069@elte.hu> <49C213A2.4040609@monstr.eu> <20090319102142.GA2579@elte.hu> <49C21DF0.10808@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C21DF0.10808@monstr.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Michal Simek <monstr@monstr.eu> wrote:

> Hi Ingo,
> > * Michal Simek <monstr@monstr.eu> wrote:
> > 
> >> WARNING: externs should be avoided in .c files
> >> #110: FILE: arch/microblaze/kernel/microblaze_ksyms.c:45:
> >> +extern void __umodsi3(void);
> >>
> >> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> >> #111: FILE: arch/microblaze/kernel/microblaze_ksyms.c:46:
> >> +EXPORT_SYMBOL(__umodsi3);
> > 
> > externs should be in header files.
> > 
> > The rest indeed looks like false positives. Thanks for addressing 
> > these things so quickly!
> 
> you are welcome - I can quickly test and add all changes to git.
> 
> Is it good style separate extern definition and EXPORT_SYMBOL?
> 
> I have three choices?
> 1. keep extern + EXPORT_SYMBOL below  - current style
> 2. move only extern to header file
> 3. move extern and EXPORT_SYMBOL to header.
> 
> What is preferable way?

Where are the symbols defined - by gcc's library?

	Ingo
