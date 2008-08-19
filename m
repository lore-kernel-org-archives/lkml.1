Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYHSNTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYHSNTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYHSNTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:19:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYHSNTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:19:22 -0400
Date: Tue, 19 Aug 2008 15:18:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Robert Richter <robert.richter@amd.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile + hibernation = badness
Message-ID: <20080819131847.GA31605@elte.hu>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <48AA1E42.6070802@linux.intel.com> <19f34abd0808190012r4418cc4egf9bc25a52056af41@mail.gmail.com> <20080819094905.GA20590@elte.hu> <48AAB8B6.3020802@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AAB8B6.3020802@linux.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

>> Andi, another issue: your patch had 5 spurious whitespace errors. 
>> This is a reoccuring, many years pattern of behavior from you and you 
>> need to fix your workflow to send less sloppy patches.
>
> Yes I forgot you define patch cleanness based on white space.
>
> Seriously, It's actually new -- i did this one in git directly instead 
> of quilt and git-commit doesn't seem to know how to drop them. In my 
> older quilt workflow they were always automatically dropped since many 
> years. Both emacs and vim add them and I don't plan to switch editors, 
> sorry.

Thousands of other kernel developers get it right and manage to submit 
clean patches, so i think you are not trying very hard to actually solve 
this problem - and your flippant and obtrusive answers do not make it 
very easy to work with you as a contributor.

>> I fixed up the problems of this patch, no need to resend.
>
> I hope you fixed the typos in the commit log too (it really was just a 
> RFC test patch)

You've put your signoff in there and Vegard has tested it. The general 
principle on lkml is that patches can be marked as do-not-apply-yet by 
adding something like this:

 Not-Signed-off-by: Andi Kleen <ak@linux.intel.com>

or by not adding a SOB line at all. In that case i either ask people for 
the SOB or apply them at my own risk.

Thanks,

	Ingo
