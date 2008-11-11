Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYKKJrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYKKJrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYKKJrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:47:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYKKJrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:47:01 -0500
Date: Tue, 11 Nov 2008 10:46:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: Make NUMA on 32-bit depend on BROKEN
Message-ID: <20081111094617.GB16496@elte.hu>
References: <200811102152.47901.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811102152.47901.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: x86: Make NUMA on 32-bit depend on BROKEN
> 
> While investigating the failure of hibernation on 32-bit x86 with 
> CONFIG_NUMA set, as described in this message 
> http://marc.info/?l=linux-kernel&m=122634118116226&w=4 I asked some 
> people for help and I was told that it wasn't really worth the 
> effort, because CONFIG_NUMA was generally broken on 32-bit x86 
> systems and it shouldn't be used in such configs.  For this reason, 
> make CONFIG_NUMA depend on BROKEN instead of EXPERIMENTAL on x86-32.

Actually, it works just fine on a wide range of 32-bit systems that i 
have, so NAK.

Hibernation might not work but that's i believe a NUMA<->HIBERNATION 
interaction issue, we need to fix that. Regular system bootup and 
stress-tests work just fine.

	Ingo
