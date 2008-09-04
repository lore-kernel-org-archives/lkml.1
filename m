Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbYIDOjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbYIDOjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYIDOjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:39:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbYIDOjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:39:35 -0400
Date: Thu, 4 Sep 2008 16:39:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rui Sousa <rui.p.m.sousa@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATH] Fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is
	not set
Message-ID: <20080904143918.GA28095@elte.hu>
References: <200809031753.07292.rui.p.m.sousa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809031753.07292.rui.p.m.sousa@gmail.com>
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


* Rui Sousa <rui.p.m.sousa@gmail.com> wrote:

> Hi,
> 
> This patch fixes compilation if CONFIG_TRACE_IRQFLAGS_SUPPORT is ever 
> disabled (which is currently not allowed by Kconfig). Alternatively we 
> could just remove the option altogether and the associated code paths. 
> Since the compilation error has been in the tree for at least two 
> years and no one noticed it, I guess we don't really have the need for 
> CONFIG_TRACE_IRQFLAGS_SUPPORT=n. Boot tested on x86 UP.

applied to tip/core/locking - thanks Rui.

since you fixed it i prefer the fix over the removal. We could still 
remove the !TRACE_IRQFLAGS_SUPPORT now (in a separate commit) and 
simpify this header a bit that way. Thus if someone needs the 
!TRACE_IRQFLAGS_SUPPORT mode of build for future work, it can be 
restored via a simple revert.

	Ingo
