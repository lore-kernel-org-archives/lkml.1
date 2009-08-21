Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZHUUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZHUUJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZHUUJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:09:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbZHUUJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:09:20 -0400
Date: Fri, 21 Aug 2009 22:09:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: properly annotate alternatives.c
Message-ID: <20090821200908.GF5356@elte.hu>
References: <4A8BC8A00200007800010823@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8BC8A00200007800010823@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> Some of the NOPs tables aren't used on 64-bits, quite some code and
> data is needed post-init for module loading only, and a couple of
> functions aren't used outside that file (i.e. can be static, and don't
> need to be exported).
> 
> The change to __INITDATA/__INITRODATA is needed to avoid an assembler
> warning.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> 
> ---
>  arch/x86/include/asm/alternative.h |    7 ----
>  arch/x86/kernel/alternative.c      |   56 +++++++++++++++++++++----------------
>  include/linux/init.h               |   12 ++++++-
>  3 files changed, 42 insertions(+), 33 deletions(-)

looks like a nice improvement. Sam, what do you think?

	Ingo
