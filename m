Return-Path: <linux-kernel-owner+w=401wt.eu-S1765063AbYDVTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765063AbYDVTYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760034AbYDVTYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:24:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758768AbYDVTYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:24:00 -0400
Date: Tue, 22 Apr 2008 21:23:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 x86/latest] x86_64 ia32 ptrace: use
	compat_ptrace_request for siginfo
Message-ID: <20080422192345.GA12588@elte.hu>
References: <20080422192020.C5DDF270381@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422192020.C5DDF270381@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0533]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> This removes the special-case handling for PTRACE_GETSIGINFO and 
> PTRACE_SETSIGINFO from x86_64's sys32_ptrace.  The generic 
> compat_ptrace_request code handles these.

thanks Roland, applied.

	Ingo
