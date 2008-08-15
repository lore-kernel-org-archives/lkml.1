Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYHOOTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYHOOTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYHOOTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:19:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbYHOOTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:19:11 -0400
Date: Fri, 15 Aug 2008 16:18:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       michael@free-electrons.com
Subject: Re: [PATCH 1/1] [x86] Configuration options to compile out x86 CPU
	support code
Message-ID: <20080815141855.GB12954@elte.hu>
References: <1217929519-10527-1-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217929519-10527-1-git-send-email-thomas.petazzoni@free-electrons.com>
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


* Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> This patch adds some configuration options that allow to compile out 
> CPU vendor-specific code in x86 kernels (in arch/x86/kernel/cpu). The 
> new configuration options are only visible when CONFIG_EMBEDDED is 
> selected, as they are mostly interesting for space savings reasons.
> 
> An example of size saving, on x86 with only Intel CPU support:
> 
>    text	   data	    bss	    dec	    hex	filename
> 1125479	 118760	 212992	1457231	 163c4f	vmlinux.old
> 1121355	 116536	 212992	1450883	 162383	vmlinux
>   -4124   -2224       0   -6348   -18CC +/-
> 
> However, I'm not exactly sure that the Kconfig wording is correct with 
> regard to !64BIT / 64BIT.

applied to tip/x86/cpu, thanks Thomas. (I've done a trivial cleanup: 
converted the macro to an inline.)

Peter, do you like this version of the patch or would you like further 
improvements?

	Ingo
