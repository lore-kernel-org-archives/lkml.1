Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYC1K0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYC1K0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYC1K0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:26:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50388 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbYC1K0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:26:41 -0400
Date: Fri, 28 Mar 2008 11:25:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Rehbach <markus.rehbach@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer
	dereference
Message-ID: <20080328102535.GD633@elte.hu>
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org> <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de> <alpine.DEB.1.10.0803280246530.3955@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0803280246530.3955@sheep.housecafe.de>
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


* Christian Kujau <lists@nerdbynature.de> wrote:

> On Thu, 27 Mar 2008, Thomas Gleixner wrote:
>> I had a lengthy bug decoding session with Ingo and we found the root
>> cause:
>> A dropped workaround for the prefetch bug in early X2s and
>> Opterons. Patch below.
>
> Although I reported it, I could not repoduce the bug. Anyway, I've 
> applied your patch to -rc7 and no BUG so far :)

yeah, the condition would normally be very sporadic and it can easily 
depend on a specific layout of your kernel image, etc.

the (updated) fix is in Linus' latest git tree as well, and in 
x86.git/latest.

	Ingo
