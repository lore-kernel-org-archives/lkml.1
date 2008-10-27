Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbYJ0SWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbYJ0SWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbYJ0SWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:22:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53379 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYJ0SWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:22:08 -0400
Date: Mon, 27 Oct 2008 19:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: unify appropriate bits from dumpstack_32 and
	dumpstack_64
Message-ID: <20081027182148.GL3046@elte.hu>
References: <20081023144006.GA14149@hmsendeavour.rdu.redhat.com> <1225128425.8714.1281501519@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225128425.8714.1281501519@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> On Thu, 23 Oct 2008 10:40:06 -0400, "Neil Horman"
> <nhorman@tuxdriver.com> said:
> > Hey all-
> > 	As promised, now that dumpstack_32 and dumpstack_64 have so many bits in
> > common, we should merge the in-sync bits into a common file, to prevent them
> > from diverging again.  This patch removes bits which are common between
> > dumpstack_32.c and dumpstack_64.c and places them in a common dumpstack.c
> > which is built for both 32 and 64 bit arches.  
> > 
> > Regards
> > Neil
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> A bit late, maybe, but if it matters:
> 
> Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

i've updated the commit, thanks.

	Ingo
