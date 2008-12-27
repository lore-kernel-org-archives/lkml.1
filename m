Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYL0Ka6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYL0Ka6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYL0Kat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:30:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYL0Kas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:30:48 -0500
Date: Sat, 27 Dec 2008 11:30:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic.c x2apic_preenabled and disable_x2apic
	should be static
Message-ID: <20081227103036.GE14639@elte.hu>
References: <1230049353.14358.6.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230049353.14358.6.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Impact: cleanup, reduce kernel size a bit, avoid sparse warning
> 
> Fixes sparse warning:
> arch/x86/kernel/apic.c:103:5: warning: symbol 'disable_x2apic' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/include/asm/apic.h |    2 +-
>  arch/x86/kernel/apic.c      |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

applied to tip/x86/cleanups, thanks!

	Ingo
