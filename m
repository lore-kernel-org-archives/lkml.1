Return-Path: <linux-kernel-owner+w=401wt.eu-S1761790AbYBOUVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761790AbYBOUVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbYBOUVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:21:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYBOUVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:21:22 -0500
Date: Fri, 15 Feb 2008 21:21:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix compile warning building without CONFIG_SYSCTL
Message-ID: <20080215202109.GA10970@elte.hu>
References: <47A55CA4.9090804@cn.fujitsu.com> <20080203071251.GB19020@elte.hu> <47A56DDA.9000907@cn.fujitsu.com> <47A56FEE.9000900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A56FEE.9000900@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> building without CONFIG_SYSCTL:
> 
> arch/x86/kernel/nmi_64.c:50: warning: 'unknown_nmi_panic_callback' 
> declared 'static' but never defined
> 
> This patch also fixes nmi_32.c

thanks, applied.

	Ingo
