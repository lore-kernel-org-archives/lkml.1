Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYI3LFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYI3LFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYI3LFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:05:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbYI3LFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:05:34 -0400
Date: Tue, 30 Sep 2008 13:04:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080930110459.GB12529@elte.hu>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org> <200809261525.30258.rusty@rustcorp.com.au> <48DC78F2.8060400@sgi.com> <20080927191653.GB18619@elte.hu> <48E0E73A.40803@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E0E73A.40803@sgi.com>
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

> > could you please send whatever .c changes you have already, so that 
> > we can have a look at how the end result will look like? Doesnt have 
> > to build, i'm just curious about how it looks like in practice, 
> > semantically.
> 
> 
> I will, and the full "allyesconfig" does compile.  And it's basically 
> a benign change in that the functionality is still the same.  I'm 
> currently reordering it a bit to clean it up.

btw., are the resulting instructions also expected to be the same? If 
yes then you might want to verify it all by making sure the md5's of the 
.o's do not change.

(If that's not possible (gcc decides to compile it a bit differently) 
then no big deal, just wanted to mention the possibility.)

	Ingo
