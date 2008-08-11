Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYHKUAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYHKUAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYHKT76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:59:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYHKT75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:59:57 -0400
Date: Mon, 11 Aug 2008 21:59:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Max Krasnyansky <maxk@qualcomm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <20080811195939.GA16716@elte.hu>
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com> <alpine.LFD.1.10.0808052259070.15995@nehalem.linux-foundation.org> <b6a2187b0808052342s40a3079fq6c229e3f36faca26@mail.gmail.com> <b6a2187b0808060833gc9d02caw2893ae8b021d1aa2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0808060833gc9d02caw2893ae8b021d1aa2@mail.gmail.com>
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


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Wed, Aug 6, 2008 at 2:42 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > On Wed, Aug 6, 2008 at 2:01 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >> One trivial thing to try would be to just bisect it. I assume 2.6.26 is
> > Bisecting now.
> 
> Thanks to all the great helpful suggestions from everyone, and this 
> turns out that I just need to enable the following switches, so I 
> didn't bisect further, and since it's first machine that I've tried 
> with more than 8 CPUs so I wasn't sure whether 2.6.16 has the same 
> problem, but if you wish, I could give 2.6.16 a try.
> 
> > CONFIG_X86_GENERICARCH=y
> > CONFIG_X86_BIGSMP=y
> 
> Thank you all for the great linux kernel!

i still consider a silent boot hang a bug we need to fix.

bigsmp might be required to have all cpus available on your box, but the 
kernel is still supposed to transparently fall back to less CPUs (and 
print a warning) if it cannot do that.

	Ingo
