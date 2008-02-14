Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYBNRnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYBNRnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbYBNRmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:42:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbYBNRmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:42:50 -0500
Date: Thu, 14 Feb 2008 18:42:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] Fix direct mapping alias regressin in ioremap v2
Message-ID: <20080214174237.GA24383@elte.hu>
References: <20080214165645.GA26748@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214165645.GA26748@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

>     Fix bug noticed by Ingo of __va() wrapping on 32bit

what you should realize is that had we applied your previous patch in a 
rush, it would have introduced a far more serious regression than the 
type of problem you are trying to solve. That's one of the reasons why 
we disagree with your sense of urgency.

We've got the clean fixes queued up and it's all under testing. (going 
fine so far)

Also, you only appear to have resent your fix with the obvious bug 
fixed, but it's still unclean and you do not seem to have replied to my 
main structural argument:

> > Please have a look at how we solved the "secondary alias" 64-bit 
> > problem in x86.git#mm and please resend against x86.git#mm if you 
> > still think something is missing. Thanks,

Thanks,

	Ingo
