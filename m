Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYJ0Jp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYJ0Jp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYJ0JpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:45:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbYJ0JpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:45:09 -0400
Date: Mon, 27 Oct 2008 10:44:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [PATCH 2.6.28-rc2] x86_64: remove duplicated register setup
	code in ia32 signal delivery
Message-ID: <20081027094432.GC4278@elte.hu>
References: <200810270830.m9R8UvcV029513@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810270830.m9R8UvcV029513@harpo.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> ia32_setup_rt_frame() has a duplicated code block labelled
> "Make -mregparm=3 work" for setting up the register parameters
> to the user-mode signal handler.
> 
> This is harmless but ugly. Remove the redundant assignments.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> ---
>  arch/x86/ia32/ia32_signal.c |    5 -----
>  1 file changed, 5 deletions(-)

applied to tip/x86/cleanups, thanks Mikael!

	Ingo
