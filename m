Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYEDJCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYEDJCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYEDJCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:02:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41500 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYEDJCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:02:30 -0400
Date: Sun, 4 May 2008 11:02:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Fix softlockup_thresh unaligned access and disable
	detection at runtime
Message-ID: <20080504090215.GB29318@elte.hu>
References: <20080502125644.GA31059@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502125644.GA31059@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> Fix unaligned access errors when setting softlockup_thresh on 64 bit 
> platforms.
> 
> Allow softlockup detection to be disabled by setting softlockup_thresh 
> <= 0.
> 
> Detect that boot time softlockup detection has been disabled earlier 
> in softlockup_tick.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

applied, thanks Dimitri.

	Ingo
