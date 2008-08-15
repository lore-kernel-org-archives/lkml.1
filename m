Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYHOOMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYHOOMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYHOOMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:12:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48068 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYHOOMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:12:24 -0400
Date: Fri, 15 Aug 2008 16:12:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86 (v2)
Message-ID: <20080815141207.GF14103@elte.hu>
References: <489A1844.3090502@am.sony.com> <20080811191012.GA16553@elte.hu> <48A091B7.6050601@zytor.com> <48A1EA04.7090102@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A1EA04.7090102@am.sony.com>
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


* Tim Bird <tim.bird@am.sony.com> wrote:

> +	  To compile command line arguments into the kernel,
> +         set this option to 'Y', then fill in the

FYI, this tab-to-space whitespace error caused this build failure in 
-tip testing:

arch/x86/Kconfig:1500: unknown option "set"
arch/x86/Kconfig:1501: unknown option "the"
arch/x86/Kconfig:1503: unknown option "Systems"
arch/x86/Kconfig:1504: unknown option "should"
arch/x86/Kconfig:1519: unknown option "In"
arch/x86/Kconfig:1520: unknown option "by"
arch/x86/Kconfig:1521: unknown option "file"

i fixed it up. This line was broken too:

> +         In most cases, the command line (whether built-in or provided

	Ingo
