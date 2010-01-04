Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457Ab0ADQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0ADQcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394Ab0ADQcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:32:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab0ADQcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:32:14 -0500
Date: Mon, 4 Jan 2010 17:32:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thiago Farina <tfransosi@gmail.com>
Subject: Re: linux-next: tip tree build failure
Message-ID: <20100104163159.GD23652@elte.hu>
References: <20100104235931.abcf2bc5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104235931.abcf2bc5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.2
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.2 required=5.9 tests=BAYES_00,FH_DATE_PAST_20XX autolearn=no SpamAssassin version=3.2.5
	3.2 FH_DATE_PAST_20XX      The date is grossly in the future.
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (s390x defconfig) failed like this:
> 
> kernel/panic.c:134: error: 'CALLER_ADDR0' undeclared (first use in this function)
> 
> Caused by commit eba3fe4416f3cc2ce043fb304b6c35a69dca3bdb ("kernel: Use
> CALLER_ADDR0 macro").

Thanks - apparently CALLER_ADDR0 isnt generally available. I've reverted this 
patch for now.

	Ingo
