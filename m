Return-Path: <linux-kernel-owner+w=401wt.eu-S934349AbXLQQIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbXLQQIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932946AbXLQQHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:07:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447AbXLQQHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:07:45 -0500
Date: Mon, 17 Dec 2007 17:06:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: Final kprobes rollup patches
Message-ID: <20071217160659.GC30958@elte.hu>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu> <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu> <4766841B.1040500@redhat.com> <20071217143050.GA13290@elte.hu> <476695D9.8090904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476695D9.8090904@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> > cool! Please Cc: lkml and Harvey as well so that there's less 
> > overlap in unification work - Harvey spent quite some time unifying 
> > and cleaning up the kprobes code during the past week.
> 
> Should I rewrite it based on current git tree?
> My patch includes 3 part of patches.
> - 2 Bugfix patches (which is not merged yet.)
> - 2 booster patches (ditto)
> - 2 unification patches (most of this patches are already done by Harvey's patch)

would it be easier/more robust to first did the unification patches and 
then get the bugfixes and new features in? That would give us your 
bugfixes and new features on both 32-bit and 64-bit at the same time.

feel free to do whichever approach you prefer - but it would be nice to 
preserve the unification and cleanup work done by Harvey.

btw., is any of your bugfixes 2.6.24 material?

	Ingo
