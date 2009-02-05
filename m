Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZBEXp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZBEXp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbZBEXpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:45:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbZBEXpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:45:40 -0500
Date: Fri, 6 Feb 2009 00:45:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org, glommer@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] x86: unify fixmap.h
Message-ID: <20090205234529.GC14203@elte.hu>
References: <1233873586-7149-1-git-send-email-gustavo@las.ic.unicamp.br> <1233873586-7149-2-git-send-email-gustavo@las.ic.unicamp.br> <1233873586-7149-3-git-send-email-gustavo@las.ic.unicamp.br> <1233873586-7149-4-git-send-email-gustavo@las.ic.unicamp.br> <1233873586-7149-5-git-send-email-gustavo@las.ic.unicamp.br> <1233873586-7149-6-git-send-email-gustavo@las.ic.unicamp.br> <1233873586-7149-7-git-send-email-gustavo@las.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233873586-7149-7-git-send-email-gustavo@las.ic.unicamp.br>
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


* Gustavo F. Padovan <gustavo@las.ic.unicamp.br> wrote:

> This patch unify fixmap_32.h and fixmap_64.h into fixmap.h.
> Things that we can't merge now are using CONFIG_X86_{32,64}
> (e.g.:vsyscall and EFI)
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
> Acked-by: Glauber Costa <gcosta@redhat.com>
> ---
>  arch/x86/include/asm/fixmap.h    |  153 +++++++++++++++++++++++++++++++++++++-
>  arch/x86/include/asm/fixmap_32.h |  119 -----------------------------
>  arch/x86/include/asm/fixmap_64.h |   94 -----------------------
>  3 files changed, 151 insertions(+), 215 deletions(-)
>  delete mode 100644 arch/x86/include/asm/fixmap_32.h
>  delete mode 100644 arch/x86/include/asm/fixmap_64.h

Please split this patch up into 3 parts:

 #1: "x86: prepare fixmap_32.h for unification"
 #2: "x86: prepare fixmap_64.h for unification"
 #3: "x86: mechanic unification of fixmap_32/64.h => fixmap.h"

ok?

That way it's reviewable what happened during the unification,
with the above patch it isnt.

	Ingo
