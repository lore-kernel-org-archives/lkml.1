Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbYBLKf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbYBLKf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760509AbYBLKfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:35:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760407AbYBLKfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:35:17 -0500
Date: Tue, 12 Feb 2008 11:34:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v9
Message-ID: <20080212103425.GA970@elte.hu>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212102636.02715270192@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212102636.02715270192@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> At any rate, I think it would be good if the hw breakpoint support in 
> kgdb were chopped out into a separate patch.  First make kgdb work 
> with no code touching debug registers at all.  Then a second patch can 
> add the hw breakpoint support.  The latter one can be mulled over or 
> replaced with a hw_breakpoint merge or just put off for a while 
> because it's a big can of worms to multiplex the use of the debug 
> registers.

agreed, and i've done that now. Thanks,

	Ingo
