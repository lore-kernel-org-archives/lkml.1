Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYE3PKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYE3PKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYE3PKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:10:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYE3PKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:10:08 -0400
Date: Fri, 30 May 2008 17:09:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: nmi - fix incorrect NMI watchdog used by default
Message-ID: <20080530150940.GA2312@elte.hu>
References: <20080528190047.GE6910@cvg> <20080530125359.GA11667@elte.hu> <20080530144449.GA6979@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530144449.GA6979@cvg>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> | > +#else
> | > +#define nmi_watchdog_default(void) do {} while (0)
> |                                   ^------
> | 
> | that doesnt work too well in a macro ... :-)
> | 
> | 	Ingo
> | 
> 
> Oh my.... maybe two prerocessor passes would help? ;-) here is an 
> updated version, please reapply, and thanks a lot for catching this 
> Ingo! Sorry for inconvenience.

no problem, already fixed in latest -tip :)

	Ingo
