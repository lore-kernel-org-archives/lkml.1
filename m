Return-Path: <linux-kernel-owner+w=401wt.eu-S1763701AbYBTAEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763701AbYBTAEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760636AbYBTAEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:04:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbYBTAEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:04:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Shi Weihua <shiwh@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
	check
In-Reply-To: Paul Mackerras's message of  Wednesday, 20 February 2008 10:21:51 +1100 <18363.25743.402510.695150@cargo.ozlabs.ibm.com>
References: <47B95C4D.6080000@cn.fujitsu.com>
	<47BA3CAB.30905@cn.fujitsu.com>
	<20080219110536.GA2683@elte.hu>
	<18363.25743.402510.695150@cargo.ozlabs.ibm.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080220000430.684DC2700F5@magilla.localdomain>
Date: Tue, 19 Feb 2008 16:04:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These patches change the behaviour of programs that longjmp out of a
> signal handler on an alternate stack, don't they?

No, they don't.  Shi Weihua's original patch had that problem.


Thanks,
Roland
