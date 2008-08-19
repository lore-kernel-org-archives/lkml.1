Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYHSJtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYHSJtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYHSJtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:49:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbYHSJtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:49:23 -0400
Date: Tue, 19 Aug 2008 11:49:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Robert Richter <robert.richter@amd.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile + hibernation = badness
Message-ID: <20080819094905.GA20590@elte.hu>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <48AA1E42.6070802@linux.intel.com> <19f34abd0808190012r4418cc4egf9bc25a52056af41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808190012r4418cc4egf9bc25a52056af41@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> This gets rid of the suspend warnings, so it looks to be a step in the 
> right direction! FWIW, you may add my Tested-by to the patch.

i've queued it up in tip/x86/oprofile - thanks guys.

Andi, another issue: your patch had 5 spurious whitespace errors. This 
is a reoccuring, many years pattern of behavior from you and you need to 
fix your workflow to send less sloppy patches. You should check your 
editor's settings (and generally you should take a good look at patches 
you send out).

I fixed up the problems of this patch, no need to resend.

	Ingo
