Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZBKLmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZBKLmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 06:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZBKLmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 06:42:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59244 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZBKLmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 06:42:37 -0500
Date: Wed, 11 Feb 2009 12:42:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86: Fix pt_regs passed by value
Message-ID: <20090211114224.GA23873@elte.hu>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
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


* Brian Gerst <brgerst@gmail.com> wrote:

> Several syscalls and one trap handler currently rely on the pt_regs
> struct being passed in by value.  This causes problems with stack
> protector, and can also cause problems with corruption due to tail-call
> optimization.  Change them to use a pointer to the pt_regs struct
> instead.

looks good! Applied them to tip:core/percpu, thanks Brian.

Tejun, i have added your Acked-by lines. (let me know if that's
incorrect). The review feedback you gave is correct and can/should
be addressed in separate patches.

	Ingo
