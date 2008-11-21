Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYKUPN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYKUPN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYKUPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:13:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbYKUPNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:13:18 -0500
Date: Fri, 21 Nov 2008 16:12:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, cpufreq@vger.kernel.org,
       stable@kernel.org, "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] x86: powernow-k8: ignore out-of-range PstateStatus
	value
Message-ID: <20081121151252.GA17052@elte.hu>
References: <20081107150811.GI15390@alberich.amd.com> <20081121080841.GD10940@alberich.amd.com> <20081121082346.GK16242@elte.hu> <20081121131609.GA10975@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121131609.GA10975@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Fri, Nov 21, 2008 at 09:23:46AM +0100, Ingo Molnar wrote:
> > 
> > nice fix! A few minor nits:
> > 
> > > +			/* a workaround for family 11h erratum 311 might cause
> > > +			   an "out-of-range Pstate if the core is in Pstate-0 */
> 
> > Please use the customary comment style:
> >   /*
> >    * Comment .....
> >    * ...... goes here:
> >    */
> 
> I don't prefer that style -- but if you do.

it's not about my or your preference. It's about what we all do in the 
kernel, documented in Documentation/CodingStyle:

| The preferred style for long (multi-line) comments is:
|
|        /*
|         * This is the preferred style for multi-line
|         * comments in the Linux kernel source code.
|         * Please use it consistently.
|         *
|         * Description:  A column of asterisks on the left side,
|         * with beginning and ending almost-blank lines.
|         */


	Ingo
