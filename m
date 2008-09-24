Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYIXIxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYIXIxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYIXIxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:53:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37415 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYIXIxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:53:12 -0400
Date: Wed, 24 Sep 2008 10:53:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] timers fixes
Message-ID: <20080924085301.GF5576@elte.hu>
References: <200809240137.40403.rjw@sisk.pl> <20080924074038.GD3655@elte.hu> <20080924074245.GA11474@elte.hu> <1222246186.8277.69.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222246186.8277.69.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2008-09-24 at 09:42 +0200, Ingo Molnar wrote:
> > Linus,
> > 
> > Please pull the latest timers-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > ------------------>
> > Marc Dionne (1):
> >       x86: prevent stale state of c1e_mask across CPU offline/online, fix
> 
> Is that all the changeset comment ? Am I the only one to find that 
> totally useless ? Or is that the mail doesn't contain the actual 
> comment, only the title followed by the patch ?

yeah. The build error is something like:

 arch/x86/kernel/process_32.c:78: warning: data definition has no type or storage class
 arch/x86/kernel/process_32.c:78: warning: type defaults to 'int' in declaration of 'c1e_remove_cpu'
 arch/x86/kernel/process_32.c:78: warning: parameter names (without types) in function declaration

	Ingo
