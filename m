Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYAAPzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYAAPzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYAAPhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbYAAPgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:37 -0500
Date: Tue, 1 Jan 2008 16:32:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Brownell <david-b@pacbell.net>, florian@openwrt.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] gpio: fix x86 build problem: gpio_keys
Message-ID: <20080101153200.GI4434@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231101837.65640746.randy.dunlap@oracle.com> <200712311040.28190.david-b@pacbell.net> <20071231111016.eaab0c70.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231111016.eaab0c70.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > Find whatever broken patch selected (on x86_64)
> > 
> >    CONFIG_GENERIC_GPIO=y
> > 
> > without actually providing that support (by providing <asm/gpio.h> and
> > an implementation backing it up).  That's the patch which broke those
> > various GPIO-dependant drivers.
> 
> OK, thanks for the direction.
> 
> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> X86_RDC321X is X86_32, so make it depend on X86_32 so that
> X86_64 random configs don't try to build RDC and fail.

thanks Randy, i have applied your fix to x86.git.

	Ingo
