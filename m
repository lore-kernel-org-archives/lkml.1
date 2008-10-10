Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbYJJPIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbYJJPIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbYJJPID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:08:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858AbYJJPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:08:01 -0400
Date: Fri, 10 Oct 2008 17:07:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipad <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: apic - unify APIC_DIVISOR
Message-ID: <20081010150745.GH11695@elte.hu>
References: <20081010150017.GD7328@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010150017.GD7328@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Use APIC_DIVISOR being set to 16 for both 32/64bit
> mode. To escape APIC timer underflow during calibration
> set it to the maximum possible value.
> 
> Also typo error (CONFG instead of proper CONFIG) fixed.
> The error was catched by Venkatesh Pallipadi, thanks a lot Venkatesh!
> See details on http://lkml.org/lkml/2008/10/9/425
> 
> Reported-by: Venkatesh Pallipad <venkatesh.pallipadi@intel.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

applied to tip/irq/sparseirq (due to lapic unification), thanks Cyrill.

( Maciej: i've added your Acked-by based on your agreement to this
  approach earlier in the thread - let me know if that does not hold for 
  this patch. )

	Ingo
