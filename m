Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYFTN7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYFTN7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbYFTN7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:59:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56233 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbYFTN7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:59:03 -0400
Date: Fri, 20 Jun 2008 15:58:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Unify crashkernel reservation for 32 and 64 bit
Message-ID: <20080620135847.GE8135@elte.hu>
References: <1213969102-17400-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213969102-17400-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernhard Walle <bwalle@suse.de> wrote:

> This patch moves the reserve_crashkernel() to setup.c and removes the 
> architecture-specific version. Both versions were more or less the 
> same.
> ---
>  arch/x86/kernel/setup.c    |   61 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/setup_32.c |   53 --------------------------------------
>  arch/x86/kernel/setup_64.c |   40 ----------------------------
>  include/asm-x86/setup.h    |    3 ++
>  4 files changed, 64 insertions(+), 93 deletions(-)

also, tip/x86 has a ton of pending changes here already so your patch 
does not apply:

 patching file arch/x86/kernel/setup.c
 Hunk #3 FAILED at 406.
 1 out of 3 hunks FAILED -- rejects in file arch/x86/kernel/setup.c
 patching file arch/x86/kernel/setup_32.c
 Hunk #1 FAILED at 429.
 1 out of 1 hunk FAILED -- rejects in file arch/x86/kernel/setup_32.c
 patching file arch/x86/kernel/setup_64.c
 Hunk #1 FAILED at 244.
 1 out of 1 hunk FAILED -- rejects in file arch/x86/kernel/setup_64.c
 patching file include/asm-x86/setup.h
 Hunk #1 FAILED at 8.
 1 out of 1 hunk FAILED -- rejects in file include/asm-x86/setup.h

you can pick up tip/master via:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
