Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbYJ0PVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbYJ0PVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYJ0PUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:20:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYJ0PUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:20:54 -0400
Date: Mon, 27 Oct 2008 16:20:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: unify appropriate bits from dumpstack_32 and
	dumpstack_64
Message-ID: <20081027152021.GF5704@elte.hu>
References: <20081023144006.GA14149@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023144006.GA14149@hmsendeavour.rdu.redhat.com>
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


* Neil Horman <nhorman@tuxdriver.com> wrote:

> Hey all-
> 	As promised, now that dumpstack_32 and dumpstack_64 have so 
> many bits in common, we should merge the in-sync bits into a common 
> file, to prevent them from diverging again.  This patch removes bits 
> which are common between dumpstack_32.c and dumpstack_64.c and 
> places them in a common dumpstack.c which is built for both 32 and 
> 64 bit arches.
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  Makefile       |    2 
>  dumpstack.c    |  319 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  dumpstack.h    |   39 ++++++
>  dumpstack_32.c |  294 ----------------------------------------------------
>  dumpstack_64.c |  285 --------------------------------------------------
>  5 files changed, 363 insertions(+), 576 deletions(-)

applied to tip/x86/dumpstack, thanks Neil!

	Ingo
