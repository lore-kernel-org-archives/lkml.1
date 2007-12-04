Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbXLDM1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbXLDM1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXLDM1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:27:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50615 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbXLDM1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:27:10 -0500
Date: Tue, 4 Dec 2007 13:26:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
Message-ID: <20071204122649.GB27286@elte.hu>
References: <200711280121.18376.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711280121.18376.lenb@kernel.org>
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


* Len Brown <lenb@kernel.org> wrote:

>     So while the irq compression code on i386 should really
>     be deleted -- even before merging the x86_64 irq-overhaul,
>     this patch simply disables it on all high volume systems
>     to avoid problems #1 and #2 on most all i386 systems.
>     
>     A large system with pin numbers >=64 will still have compression
>     to conserve limited IRQ numbers for sparse IOAPICS.  However,
>     the vast majority of the planet, those with only pin numbers < 64
>     will use an identity GSI -> IRQ mapping.
>     
>     Signed-off-by: Len Brown <len.brown@intel.com>

thanks for the patch and the extensive description. I've applied this to 
x86.git. Do you agree that this has no urgency for v2.6.24 and is thus 
v2.6.25 material?

would you be interested in doing a follow-up patch as well that just 
yanks all of the irq compression code? That would keep things nicely 
bisectable and testable - the second, larger patch would be a NOP in 
theory on most systems.

	Ingo
