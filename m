Return-Path: <linux-kernel-owner+w=401wt.eu-S1763786AbYBTADg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763786AbYBTADg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763601AbYBTAD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:03:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbYBTADZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:03:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Shi Weihua <shiwh@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
In-Reply-To: H. Peter Anvin's message of  Tuesday, 19 February 2008 15:25:12 -0800 <47BB6558.4020201@zytor.com>
References: <47B95C4D.6080000@cn.fujitsu.com>
	<47BA3CAB.30905@cn.fujitsu.com>
	<20080219110536.GA2683@elte.hu>
	<18363.25743.402510.695150@cargo.ozlabs.ibm.com>
	<47BB6558.4020201@zytor.com>
X-Zippy-Says: I need to discuss BUY-BACK PROVISIONS with at least six studio
    SLEAZEBALLS!!
Message-Id: <20080220000318.6D6382700F5@magilla.localdomain>
Date: Tue, 19 Feb 2008 16:03:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Shouldn't such programs use sigsetjmp/siglongjmp, which should reset the 
> signal stack state?

That is not really related.  The distinction doesn't really exist for
programs using the normal API (setjmp is sigsetjmp(,1)).  What siglongjmp
guarantees handled is signal mask changes, not sigaltstack.


Thanks,
Roland
