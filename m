Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYAKKt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYAKKt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYAKKtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:49:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbYAKKtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:49:51 -0500
Date: Fri, 11 Jan 2008 11:49:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86_64 save_i387_ia32 snafu
Message-ID: <20080111104932.GA1589@elte.hu>
References: <4786A9CA.2090008@zytor.com> <20080111004422.2B3F926F9A6@magilla.localdomain> <4786BE15.6040604@zytor.com> <20080111024929.37FDB26F9A9@magilla.localdomain> <4786DB3B.8070808@zytor.com> <20080111104357.8364826F9A9@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111104357.8364826F9A9@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0377]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> Sorry about this one, mea culpa.  This should go right after the "x86 
> i387 user_regset" patch, or be rolled into it.

thanks, applied. Does this explain the crash/hang problems with 32-bit 
apps on 64-bit kernels? What was the exact failure mode?

	Ingo
