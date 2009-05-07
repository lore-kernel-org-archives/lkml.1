Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZEGLJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZEGLJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZEGLJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:09:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40750 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZEGLJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:09:33 -0400
Date: Thu, 7 May 2009 13:09:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Provide _sdata in the vmlinux_*.lds.S files
Message-ID: <20090507110918.GF28398@elte.hu>
References: <20090507110648.8484.38527.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507110648.8484.38527.stgit@pc1117.cambridge.arm.com>
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

> _sdata is a common symbol defined by many architectures and made
> available to the kernel via asm-generic/sections.h. Kmemleak uses this
> symbol when scanning the data sections. The _edata symbol in
> vmlinux_64.lds.S was also moved further down to include the
> .data.read_mostly section.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/vmlinux_32.lds.S |    1 +
>  arch/x86/kernel/vmlinux_64.lds.S |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletions(-)

Please do this against the latest x86 tree:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
