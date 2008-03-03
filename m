Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYCCMv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYCCMv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYCCMuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:50:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53448 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbYCCMuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:50:46 -0500
Date: Mon, 3 Mar 2008 13:50:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303125027.GA21577@elte.hu>
References: <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303120211.GG4457@cs181133002.pp.htv.fi> <20080303121015.GA12660@elte.hu> <20080303122953.GH4457@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303122953.GH4457@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> I can only repeat that I did state several times on linux-kernel that 
> it never worked.
> 
> If you consider it my fault that noone reads my emails then you are 
> right that it's my fault...

well, i'm trying to assume the best, so please explain the following 
sequence of events to me:

1) as you said you knew about this bug - which bug causes more inlining
   overhead than hundreds of your uninlining patches combined. The bug
   was introduced ~2 years ago in -mm - before the feature hit mainline
   in v2.6.16.

2) the fix was really trivial and the intention of the feature was well 
   understood - but the feature stayed as a NOP in the upstream kernel 
   for 2 years.

still, while you clearly had interest in this general area of the kernel 
(for example you wrote hundreds of tiny uninlining patches that work 
towards a similar goal), but strangely at the same time you neither 
fixed, nor properly escallated this _far_ bigger bug that causes +2.3% 
of text bloat on x86 [more than 120K of kernel text]. In fact:

- you created bugzillas for far smaller bugs in the past, but you never
  created a bugzilla for this that i'm aware of.

- you never directly raised this issue with us: "look guys, this thing
  really is broken - please reply to me with a fix".

- you never said "this is a regression that should be fixed" to any of
  the regression lists.

in other words: for about two years you knew about a bug that should 
have been fixed the day after it got introduced.

i obviously cannot know what your intentions were with this conduct, so 
i'm eagerly awaiting your explanation for it. Thanks,

	Ingo
