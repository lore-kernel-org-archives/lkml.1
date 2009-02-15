Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZBOIES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZBOIES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 03:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZBOIEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 03:04:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZBOIEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 03:04:07 -0500
Date: Sun, 15 Feb 2009 09:03:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix typo in filter_cpuid_features()
Message-ID: <20090215080352.GB21151@elte.hu>
References: <4997CB56.7000703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4997CB56.7000703@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix wrong diabling cpu features
> 
> on amd system got strange:
> CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
> but in /proc/cpuinfo do have
> cpuid level	: 5
> 
> on intel system:
> CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
> CPU: CPU feature dca disabled due to lack of CPUID level 0x9
> but in /proc/cpuinfo do have
> cpuid level     : 11
> 
> it turns out there is one typo, and should use level member in df
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/cpu/common.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied to tip:x86/cpudetect, thanks Yinghai!

	Ingo
