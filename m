Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYKTJfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYKTJfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYKTJfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:35:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYKTJfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:35:24 -0500
Date: Thu, 20 Nov 2008 10:35:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
Message-ID: <20081120093506.GB6885@elte.hu>
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Writes to the IO APIC are paravirtualized via hypercalls, so implement
> the appropriate operations.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/Makefile    |    3 +-
>  arch/x86/xen/apic.c      |   66 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/xen/enlighten.c |    2 +
>  arch/x86/xen/xen-ops.h   |    2 +
>  4 files changed, 72 insertions(+), 1 deletion(-)

hm, why is the ioapic used as the API here, and not an irqchip?

	Ingo
