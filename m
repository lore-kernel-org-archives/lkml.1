Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbZEKLLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbZEKLLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZEKLLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:11:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39949 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbZEKLLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:11:43 -0400
Date: Mon, 11 May 2009 13:10:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Linux@zytor.com" <Linux@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
Message-ID: <20090511111058.GJ4648@elte.hu>
References: <4A05CD29.6050505@zytor.com> <C62C5B3C.AB1A%keir.fraser@eu.citrix.com> <20090510142928.66bb57bb@lxorguk.ukuu.org.uk> <4A071518.8000307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A071518.8000307@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Alan Cox wrote:
> > 
> > There are quite a few different CPUs with PAT errata. I've no idea why
> > there are so many errata about that specific bit.
> > 
> 
> I suspect it is simply because:
> 
> a) it moves around between the various page table formats;
> b) the default configuration and existing OSes don't use it;
> c) it isn't even *present* in some formats.

I also suspect those bits is also on the TLB miss critical path so 
there's probably quite a bit of extra complexity around it on the 
hardware side to keep the latency down.

	Ingo
