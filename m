Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYCJRO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYCJRO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYCJROd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:14:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYCJROc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:14:32 -0400
Date: Mon, 10 Mar 2008 18:14:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent unconditional writes to DebugCtl MSR
Message-ID: <20080310171409.GA24133@elte.hu>
References: <47D54185.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D54185.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0046]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Otherwise, enabling (or better, subsequent disabling) of single 
> stepping would cause a kernel oops on CPUs not having this MSR.
> 
> The patch could have been added a conditional to the MSR write in 
> user_disable_single_step(), but centralizing the updates seems safer 
> and (looking forward) better manageable.

thanks Jan, applied.

	Ingo
