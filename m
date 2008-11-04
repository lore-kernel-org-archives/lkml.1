Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYKDIzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYKDIzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYKDIz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:55:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbYKDIz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:55:29 -0500
Date: Tue, 4 Nov 2008 09:55:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Don't use tsc_khz to calculate lpj if notsc is
	passed.
Message-ID: <20081104085504.GA23790@elte.hu>
References: <1225739927.8168.34.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225739927.8168.34.camel@alok-dev1>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alok Kataria <akataria@vmware.com> wrote:

> x86: Don't use tsc_khz to calculate lpj if notsc is passed.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> With notsc passed on commandline, tsc may not be used for
> udelays, make sure that we do not use tsc_khz to calculate
> the lpj value in such cases.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> Cc: stable@kernel.org

applied to tip/x86/urgent, thanks Alok!

btw., i fixed this error checkpatch noticed:

ERROR: trailing whitespace
#41: FILE: arch/x86/kernel/tsc.c:838:
+^I$

total: 1 errors, 0 warnings, 0 checks, 20 lines checked

	Ingo
