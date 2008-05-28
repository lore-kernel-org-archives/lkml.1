Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYE1TMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYE1TMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbYE1TMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:12:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbYE1TMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:12:18 -0400
Date: Wed, 28 May 2008 21:08:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86: nmi - fix incorrect NMI watchdog used by default
Message-ID: <20080528190843.GA13803@elte.hu>
References: <20080528190047.GE6910@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528190047.GE6910@cvg>
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

> The commit
> 
> 	commit 4b82b277707a39b97271439c475f186f63ec4692
> 	Author: Cyrill Gorcunov <gorcunov@gmail.com>
> 	Date:   Sat May 24 19:36:35 2008 +0400
> 
> set nmi_watchdog to NMI_IO_APIC as by default. This causes hangs on 
> some machines with buggy watchdogs. Fix it - i.e. restore old 
> behaviour.
> 
> Thanks to Sitsofe Wheeler and Adrian Bunk for catching the problem and 
> Maciej W. Rozycki for explanation what is going on there.

applied, thanks Cyrill.

	Ingo
