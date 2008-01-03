Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbYACLDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbYACLDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYACLD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:03:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYACLD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:03:27 -0500
Date: Thu, 3 Jan 2008 12:03:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [15/20] x86: Move X86_FEATURE_CONSTANT_TSC into early
	cpu feature detection
Message-ID: <20080103110317.GH29194@elte.hu>
References: <20080103149.088038000@suse.de> <20080103005011.06E9914D40@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103005011.06E9914D40@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> Need this in the next patch in time_init and that happens early.
> 
> This includes a minor fix on i386 where early_intel_workarounds() 
> [which is now called early_init_intel] really executes early as the 
> comments say.

thanks, applied. I'll wait for Thomas to comment on the TSC bits though. 
(but as long as we carry this patch in x86.git it should make your 
future patching efforts easier.)

	Ingo
