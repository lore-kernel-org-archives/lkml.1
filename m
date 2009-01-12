Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZALLSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZALLSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZALLSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:18:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZALLSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:18:40 -0500
Date: Mon, 12 Jan 2009 12:18:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
Message-ID: <20090112111827.GB18265@elte.hu>
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz> <20090112105202.GF10405@elte.hu> <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 12 Jan 2009, Ingo Molnar wrote:
> 
> > > with Linus' tree (ae04d14015) doesn't build for me with
> > > 
> > > arch/x86/kernel/ldt.c: In function 'alloc_ldt':
> > > arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
> > > arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'
> > > 
> > > Config on http://www.jikos.cz/jikos/junk/.config
> > 
> > hm, it builds fine here with your config. Did .28 build fine for you? The 
> > only change to this file since .28 has been Jaswinder's "423a540: x86: 
> > ldt.c fix style problems".
> 
> Puzzled. On one system, I still get this build error even after make 
> mrpoper (I use this machine to build kernel routinely, so it certainly 
> didn't happen a few days ago).
> 
> But I just tried on different system, and there is builds flawlessly. 
> It's gcc 4.3.1 vs 4.3.2. I will check a little bit more.

beyond mrproper you might want to try 'git checkout HEAD . -f' as well, to 
get a forced checkout of the current working tree. Should there be any 
corruption in any of the source code files this will get rid of it.

	Ingo
