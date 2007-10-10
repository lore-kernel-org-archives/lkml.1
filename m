Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbXJJL0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbXJJL0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 07:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXJJL0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 07:26:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36765 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbXJJL0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 07:26:17 -0400
Date: Wed, 10 Oct 2007 13:26:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/6] scheduler: Remove some unnecessary gotos in
	sched.c
Message-ID: <20071010112612.GA11143@elte.hu>
References: <200710071059.126674000@suse.de> <20071007205954.4053C13E06@wotan.suse.de> <20071009191730.GA8887@elte.hu> <20071010005546.GA756@bingen.suse.de> <20071010112540.GA10717@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010112540.GA10717@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1410]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > this crashes during bootup - removed it for now.
> > 
> > Boots here and also survived LTP and some other tests. Hmm; i had an 
> > early version that hung because I forgot a break. Perhaps I forgot 
> > quilt refresh. Can you check you have this version?
> 
> hm, i've got your latest. I did some more debugging today and this was 
> a red herring: it turns out that it was not your patch causing this 
> problem, it triggered with your patch only because of a subtle .config 
> difference that i overlooked. Sorry!

(and of course your patch is back in.)

	Ingo
