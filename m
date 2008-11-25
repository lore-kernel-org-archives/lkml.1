Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYKYOrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYKYOrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYKYOqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:46:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57360 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYKYOqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:46:51 -0500
Date: Tue, 25 Nov 2008 15:46:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       socketcan-users@lists.berlios.de
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
Message-ID: <20081125144633.GB14147@elte.hu>
References: <1227613431.4259.1537.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227613431.4259.1537.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Hi,
> 
> This is an attempt at removing some of the hrtimer complexity by 
> reducing the number of callback modes to 1.
> 
> This means that all hrtimer callback functions will be ran from 
> HARD-irq context.

>  9 files changed, 37 insertions(+), 293 deletions(-)

very nice :-)

Applied to tip/timers/hrtimers and started testing it, lets see what 
happens ;-)

	Ingo
