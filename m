Return-Path: <linux-kernel-owner+w=401wt.eu-S933518AbYB2Tp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbYB2Tp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758666AbYB2TpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:45:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758683AbYB2TpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:45:17 -0500
Date: Fri, 29 Feb 2008 20:44:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, alexey.zaytsev@gmail.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Message-ID: <20080229194457.GB21249@elte.hu>
References: <20080228201315.GA30736@elte.hu> <20080228201613.GA30999@elte.hu> <18375.59486.392919.984544@cargo.ozlabs.ibm.com> <20080229.104235.192308716.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229.104235.192308716.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Paul Mackerras <paulus@samba.org>
> Date: Fri, 29 Feb 2008 22:11:26 +1100
> 
> > On powerpc we use the timebase register, which is synchronized across
> > CPUs, so if this will add unnecessary overhead, we will want to way to
> > turn it off on powerpc (assuming this ends up going upstream).
> 
> Similarly on sparc64, all of our TSCs are fully synchronized so this 
> complexity is completely unnecessary.

i suspect for them the easiest way is to expose time_sync_thresh and let 
them set it to ULONG_MAX - which skips all synchronization overhead and 
complexity.

	Ingo
