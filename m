Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZCBVS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZCBVS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZCBVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:18:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55549 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZCBVSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:18:02 -0500
Date: Mon, 2 Mar 2009 22:17:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Message-ID: <20090302211747.GC20228@elte.hu>
References: <1235996477.5330.174.camel@laptop> <20090302144303.GA30136@elte.hu> <20090302154748.GB14217@parisc-linux.org> <1236009588.5330.729.camel@laptop> <20090302210158.GA18479@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302210158.GA18479@flint.arm.linux.org.uk>
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


* Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Mon, Mar 02, 2009 at 04:59:48PM +0100, Peter Zijlstra wrote:
> > The idea is to mandate IRQF_DISABLED for everybody, and since it doesn't
> > do any good to have it a flag if you have it always enabled, remove
> > it ;-)
> 
> Bad.  Very bad.

btw., your mailer is very broken and generates:

Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>

this messes up the To: line in a big way. Please stop it.

	Ingo
