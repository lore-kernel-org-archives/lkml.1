Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbYIHNeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbYIHNeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYIHNdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:33:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYIHNdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:33:53 -0400
Date: Mon, 8 Sep 2008 15:33:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] x86: make 64 bit to use amd.c
Message-ID: <20080908133335.GA11993@elte.hu>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com> <1220835538-18280-7-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220835538-18280-7-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> ---
>  arch/x86/Kconfig.cpu         |   10 +-
>  arch/x86/kernel/cpu/Makefile |    3 +-
>  arch/x86/kernel/cpu/amd_64.c |  473 ------------------------------------------
>  3 files changed, 2 insertions(+), 484 deletions(-)
>  delete mode 100644 arch/x86/kernel/cpu/amd_64.c

nice! Applied these patches to tip/x86/unify-cpu-detect:

 ff73152: x86: make 64 bit to use amd.c
 2a02505: x86: make amd_64 have 32 bit code
 6c62aa4: x86: make amd.c have 64bit support code
 8d71a2e: x86: merge header in amd_64.c
 2b86473: x86: add srat_detect_node for amd64
 c58606a: x86: remove duplicated force_mwait
 11fdd25: x86: cpu make amd.c more like amd_64.c v2

thanks Yinghai,

	Ingo
