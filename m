Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYKLUlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYKLUlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYKLUlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:41:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYKLUk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:40:59 -0500
Date: Wed, 12 Nov 2008 21:40:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "lenb@kernel.org" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [Linux 2.6.28-rc4] BUG: using smp_processor_id() in
	preemptible [00000000] code: suspend_to_disk/2934
Message-ID: <20081112204042.GA13350@elte.hu>
References: <8db1092f0811121030t1977b3bbu8340b582694d1e65@mail.gmail.com> <alpine.LFD.2.00.0811121046360.3468@nehalem.linux-foundation.org> <20081112192128.GA17667@elte.hu> <8db1092f0811121234p3be15e29n5fd684e387977dab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db1092f0811121234p3be15e29n5fd684e387977dab@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> 2008/11/12 Ingo Molnar <mingo@elte.hu>:
> 
> >
> > i've queued up the fix below in tip/sched/urgent - Maciej, could you
> > please test it? I've build and boot tested it.
> >
> 
> Suspend to disk works OK now. Thanks.
> 
> Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

thanks Maciej!

	Ingo
