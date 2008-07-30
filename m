Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbYG3SwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbYG3SwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYG3SwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:52:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47004 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYG3SwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:52:03 -0400
Date: Wed, 30 Jul 2008 20:51:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT-PULL] time.c integration
Message-ID: <20080730185148.GA12336@elte.hu>
References: <200807290103.m6T13vt3000862@file.rdu.redhat.com> <20080730185007.GB26389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730185007.GB26389@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Also, please do smaller steps while bringing both time_32.c and 
> time_64.c up into their final forms (and do it in multiple commits), 
> and make sure each step compiles on their respective defconfig. time.c 
> details are historically fragile, i'd not be surprised if this series 
> was the target of bisection efforts.

i briefly put your current variant into tip/master, but it has build 
problems as well:

arch/x86/kernel/io_apic_64.c: In function 'check_timer':
arch/x86/kernel/io_apic_64.c:2016: error: 'timer_ack' undeclared (first use in this function)
arch/x86/kernel/io_apic_64.c:2016: error: (Each undeclared identifier is reported only once
arch/x86/kernel/io_apic_64.c:2016: error: for each function it appears in.)

with:

  http://redhat.com/~mingo/misc/config-Wed_Jul_30_20_50_17_CEST_2008.bad

	Ingo
