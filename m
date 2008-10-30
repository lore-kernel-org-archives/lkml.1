Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYJ3V2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYJ3V2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYJ3V2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:28:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbYJ3V2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:28:07 -0400
Date: Thu, 30 Oct 2008 22:27:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use CONFIG_X86_SMP instead of CONFIG_SMP
Message-ID: <20081030212753.GD30303@elte.hu>
References: <1225400739.19324.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225400739.19324.18.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> >From 6e5fbb4691fd68f5b03608c5d8d96e4f189e623a Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 29 Oct 2008 13:11:48 -0500
> Subject: [VOYAGER] x86: use CONFIG_X86_SMP instead of CONFIG_SMP
> 
> CONFIG_SMP is used for features which work on *all* x86 boxes. 
> CONFIG_X86_SMP is used for standard PC like x86 boxes (for things 
> like multi core and apics)

i've applied your fix to tip/x86/urgent, as it's obviously correct in 
the current scheme of things, thanks!

but that needless build-time distinction should go away. We can now 
support a whole host of 'weird' SMP boxes via genapic and x86_quirks.

	Ingo
