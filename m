Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZADMil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZADMil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZADMic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:38:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZADMib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:38:31 -0500
Date: Sun, 4 Jan 2009 13:38:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ia64: cpumask fix for is_affinity_mask_valid()
Message-ID: <20090104123816.GA15472@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <20090103115904.GA440@elte.hu> <200901041413.12187.rusty@rustcorp.com.au> <49603902.40205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49603902.40205@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Rusty Russell wrote:
> > On Saturday 03 January 2009 22:29:04 Ingo Molnar wrote:
> >> update it to cpumask_var_t.
> > 
> > Please change it to a const struct cpumask_t *.

yeah.

> > It should be const, and of course 'const cpumask_var_t' isn't the 
> > same.
> > 
> > Thanks,
> > Rusty.
> 
> I have a fixup patch coming to correct that and remove an unneeded 
> cpumask off the stack.

ok, will wait for that.

	Ingo
