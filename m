Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYKTMQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYKTMQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYKTMQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:16:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYKTMQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:16:43 -0500
Date: Thu, 20 Nov 2008 13:16:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc5 05/11] kmemleak: Add support for i386
Message-ID: <20081120121633.GG20724@elte.hu>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com> <20081120113056.16607.20723.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120113056.16607.20723.stgit@pc1117.cambridge.arm.com>
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


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> This patch adds the kmemleak-related entries to the vmlinux.lds.S
> linker script.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/x86/kernel/vmlinux_32.lds.S |    1 +

a small detail: a better changelog would be:

|   x86: provide _sdata
|
|   Impact: provide generic symbol
|
|   _sdata is a common symbol defined by many architectures and made
|   available to the core kernel via asm-generic/sections.h.
|
|   Add it to x86 too, so that kmemleak can make use of it.

it is more informative this way, and would be in the customary x86 
commit style.

	Ingo
