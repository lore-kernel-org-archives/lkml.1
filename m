Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYJVPhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYJVPhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJVPho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:37:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53961 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYJVPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:37:44 -0400
Date: Wed, 22 Oct 2008 17:37:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/7] post x86 merge section mismatch fixes
Message-ID: <20081022153729.GJ23060@elte.hu>
References: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223804330-10881-1-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1858]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> [PATCH 1/7] x86, xsave: fix section mismatch warning - setup_xstate_init
> [PATCH 2/7] x86: fix section mismatch warning - reserve_region_with_split
> [PATCH 3/7] x86: fix section mismatch warning - apic_flat
> [PATCH 4/7] x86: fix section mismatch warning - apic_physflat
> [PATCH 5/7] x86: fix section mismatch warning - apic_x2apic_uv_x
> [PATCH 6/7] x86: fix section mismatch warning - apic_x2apic_cluster
> [PATCH 7/7] x86: fix section mismatch warning - apic_x2apic_phys

applied these to tip/x86/urgent:

 3cfba08: x86: fix section mismatch warning - apic_x2apic_phys
 2caa371: x86: fix section mismatch warning - apic_x2apic_cluster
 f8827c0: x86: fix section mismatch warning - apic_x2apic_uv_x
 fae1721: x86: fix section mismatch warning - apic_physflat
 983f91f: x86: fix section mismatch warning - apic_flat

the warnings are harmless but worth fixing nevertheless.

Thanks Marcin!

	Ingo
