Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYJ3RxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYJ3RxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYJ3RxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:53:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49708 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbYJ3RxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:53:11 -0400
Date: Thu, 30 Oct 2008 18:52:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Aristeu Rozanski <aris@redhat.com>
Subject: Re: [RFC -tip] x86: nmi - add sensible names to nmi_watchdog boot
	param
Message-ID: <20081030175255.GA4675@elte.hu>
References: <20081030161646.GC19888@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030161646.GC19888@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Add sensible names as "lapic" and "ioapic" to
> nmi_watchdog boot parameter. Sometimes it is not
> that easy to recall what exactly nmi_watchdog=1
> does mean so we allow the using of symbolic names here.
> 
> Old numeric values remain valid.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
>  arch/x86/kernel/nmi.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)

ok, that makes quite a bit of sense. Peter, any objections?

	Ingo
