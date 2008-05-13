Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYEMM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYEMM3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYEMM3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:29:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbYEMM3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:29:36 -0400
Date: Tue, 13 May 2008 14:28:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] x86 user_regset_view table fix for ia32 on 64-bit
Message-ID: <20080513122859.GC14973@elte.hu>
References: <20080509224344.152FD26FA85@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509224344.152FD26FA85@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0095]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> The user_regset_view table for the 32-bit regsets on the 64-bit build 
> had the wrong sizes for the FP regsets.  This bug had no user-visible 
> effect (just on kernel modules using the user_regset interfaces and 
> the like). But the fix is trivial and risk-free.

applied, thanks Roland.

	Ingo
