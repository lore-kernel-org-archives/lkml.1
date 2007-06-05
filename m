Return-Path: <linux-kernel-owner+w=401wt.eu-S1764018AbXFEJkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764018AbXFEJkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763229AbXFEJkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:40:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48345 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763202AbXFEJkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:40:04 -0400
Date: Tue, 5 Jun 2007 11:39:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1
Message-ID: <20070605093958.GA26135@elte.hu>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070605091151.GA18385@elte.hu> <20070605022411.f303d28b.akpm@linux-foundation.org> <20070605093349.GA24956@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605093349.GA24956@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> yeah. I tried !hres and !dynticks too and that doesnt make any 
> difference to the end result - so my guess is on the NMI watchdog 
> re-programming thing on K8 CPUs (running the 32-bit kernel), which is 
> done in every NMI tick. check_watchdog() for some reason thought 
> there's no NMI, and later on an NMI still arrived? Something like 
> that.

i have put an early_printk() into the NMI handler but it never triggers.

	Ingo
