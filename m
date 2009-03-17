Return-Path: <linux-kernel-owner+w=401wt.eu-S1763197AbZCQKvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197AbZCQKvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbZCQKvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:51:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbZCQKvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:51:46 -0400
Date: Tue, 17 Mar 2009 11:51:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PULL] x86 cpumask work
Message-ID: <20090317105121.GJ6477@elte.hu>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903161333.16632.rusty@rustcorp.com.au> <20090316084802.GB1062@elte.hu> <200903171450.34549.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903171450.34549.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 16 March 2009 19:18:02 Ingo Molnar wrote:
> > 
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > As the comments says, it can only be NULL during boot of the first CPU.
> > > 
> > > start_kernel -> check_bugs -> identify_boot_cpu -> identify_cpu
> > >   -> select_idle_routine.
> > > 
> > > Did you want me to panic if it fails?
> > 
> > Ah, ok. But i think it's very unobvious to embedd a "once per 
> > bootup" dynamic allocation like that. Please put it into a 
> > separate init routine instead. That way select_idle() [which 
> > runs during every CPU hotplug event] wont have this allocation.
> 
> There wasn't an obvious place to put the init; I've created one.
> 
> How's this?

looks perfect. Should i apply or do you want to send a pull 
request?

	Ingo
