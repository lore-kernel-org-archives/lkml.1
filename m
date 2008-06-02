Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYFBJZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYFBJZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYFBJY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:24:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYFBJY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:24:58 -0400
Date: Mon, 2 Jun 2008 11:24:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86: IO-APIC - use NMI_NONE instead of numeric constant
Message-ID: <20080602092437.GC22060@elte.hu>
References: <20080529183230.GC6937@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529183230.GC6937@cvg>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Not sure but maybe it is better to use NMI_DISABLED, will take a look. 
> But for now this patch is not change anything in logic so it will not 
> hurt/broke the kernel. For most cases nmi_watchdog assignment is by 
> one of NMI_* macro so I think there it make sense too.

applied to -tip, thanks Cyrill.

	Ingo
