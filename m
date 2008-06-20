Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbYFTPhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbYFTPhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbYFTPgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:36:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37024 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665AbYFTPgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:36:53 -0400
Date: Fri, 20 Jun 2008 17:36:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Bisecting tip/auto-x86-next?
Message-ID: <20080620153626.GE17373@elte.hu>
References: <485AFC9B.7090502@gmail.com> <20080620101722.GD17692@elte.hu> <d1af83620806200437p7c3817d8i381a99f92f47fd4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1af83620806200437p7c3817d8i381a99f92f47fd4f@mail.gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> > hm, could you send me the config that triggered this?
> 
> I will do so tonight when I am home again.  It is a UP AMD64 box with 
> a VIA chipset, if that helps.
> 
> > btw., you can probably ignore this one safely. Also please tell me 
> > at which commit ID you were at when you triggered this warning.
> 
> Good to know - I will get the commit ID tonight as well, although 
> wouldn't following the same bisection sequence that I did give you the 
> same bisection point?  I guess that would assume that linus/master and 
> auto-x86-next haven't changed much since last night, which might not 
> be correct.

yeah, you'd probably not hit that warning with the x86/gart bisection 
sequence. (Assuming the bug is introduced in that branch - so you should 
first check whether pure x86/gart kernel triggers the problem too.)

If you still have the commit ID around then please send it - if you 
dont, no problem, it's no big issue. I wanted to check how wide the 
bisection window is where the warning triggers.

	Ingo
