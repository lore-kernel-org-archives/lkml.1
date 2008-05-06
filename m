Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbYEFMKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbYEFMKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYEFMKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:10:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48640 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbYEFMKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:10:19 -0400
Date: Tue, 6 May 2008 14:10:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Oops with strace_test
Message-ID: <20080506121005.GJ32591@elte.hu>
References: <20080430121202.GD18314@alice> <20080505100008.GA2354@alice> <20080505180053.GB5576@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505180053.GB5576@slug>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0078]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederik Deweerdt <deweerdt@free.fr> wrote:

> Hi Eric,
> 
> This appears to be caused by init_fpu() missing from the 
> restore_sigcontext->restore_i387->restore_fpu_checking code path.
> 
> I believe that moving the init_fpu() call from math_state_restore to 
> restore_fpu_checking should fix the problem?

thanks Eric and Frederik for tracking this down. Eric, does Frederik's 
patch fix the problem for you?

	Ingo
