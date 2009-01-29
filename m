Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZA2X1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZA2X1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZA2X1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:27:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53193 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZA2X1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:27:36 -0500
Date: Fri, 30 Jan 2009 00:27:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old
	subarchitecture code
Message-ID: <20090129232728.GD30601@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu> <87vdryw6ql.fsf@basil.nowhere.org> <eada2a070901291324t1a2dbb08hbff7b026c77d69cd@mail.gmail.com> <20090129221402.GA1984@elte.hu> <eada2a070901291458m24249390xc0df8c11a2d2fd15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eada2a070901291458m24249390xc0df8c11a2d2fd15@mail.gmail.com>
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


* Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:

> On Thu, Jan 29, 2009 at 2:14 PM, Ingo Molnar <mingo@elte.hu> wrote:

> > At this point there's no technical need to kill it - it's a 
> > zero-overhead thing tucked away into a single .c module in 
> > arch/x86/kernel/numaq_32.c. I even consolidated most of its headers in 
> > that file, to reduce its cross section.
> 
> Wish we'd have piped up earlier to save you a bit of work.

Well bigsmp wasnt going to go away anytime soon so the de-subarching and 
unification work had to be done anyway. NUMAQ came along for the ride ;-) 
I've got some more restructuring plans in this area so the time was well 
spent in any case.

> We can make the NUMAQ's beep still, if not boot.  :)
> 
> Reality is they're just not worth the effort any more and there's no 
> sign of anybody else having them.  Assuming your code goes in for 2.6.30 
> it'll be easy to drop NUMAQ support.  Even if there's not much downside 
> there's also not much reason to leave it in but marked 
> deprecated/broken.

Yes, unless there's major stability problems with the x86/apic branch 
we'll merge it into v2.6.30. NUMAQ is a single .c module now 
(default-disabled) so not much of a concern.

	Ingo
