Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031456Ab0B1HOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 02:14:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47207 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031430Ab0B1HOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 02:14:50 -0500
Date: Sun, 28 Feb 2010 08:14:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100228071405.GA14205@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <201002271323.14402.rjw@sisk.pl>
 <20100227124710.GA21164@elte.hu>
 <201002272007.43042.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002272007.43042.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > - and without burdening developers to consider cases they have no good 
> > ways to test.  Why should rare architectures be more important than those 
> > other rare forms of Linux usage?
> 
> Because the Linus' tree is supposed to build on those architectures. [...]

That's not actually true: Linus on multiple occasions has said that only the 
major architectures (x86, powerpc, ARM and a few others) are 'required' to 
build and that the others should be left to fail to build and should be 
_forced to get their act together_.

> [...]  As long as that's the case, linux-next should build on them too.

No, and IMO linux-next is clearly over-interpreting this bit. Linux is not 
supposed to build on all architectures. Maybe that's a core bit of a 
misunderstanding (on either my or on sfr's side) and it should be clarified 
...

	Ingo
