Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbYJIMUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbYJIMUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbYJIMT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:19:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356AbYJIMT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:19:59 -0400
Date: Thu, 9 Oct 2008 14:19:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] UV: cosmetic fix to interrupt handler definition
Message-ID: <20081009121946.GA1558@elte.hu>
References: <E1Knh2A-0000HU-WA@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Knh2A-0000HU-WA@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1281]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> The UV Broadcast Assist Unit (BAU) interrupt handler is erroneously
> declared with a hardcoded vector 220 (that was used during testing).
> It should be declared with the vector that is reserved for it.
> 
> The interrupt handler does not use the 220 that is pushed onto its
> stack, so this error had no runtime effect.
> 
> Diffed against 2.6.27-rc8
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>

applied to tip/x86/uv, thanks Cliff!

	Ingo
