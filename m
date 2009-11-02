Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZKBTgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZKBTgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZKBTgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:36:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbZKBTga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:36:30 -0500
Date: Mon, 2 Nov 2009 20:36:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joe Perches <joe@perches.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       laijs@cn.fujitsu.com, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra
	check
Message-ID: <20091102193623.GB9948@elte.hu>
References: <b8bf37780911020926rd5e40b1h957c803f7bb21196@mail.gmail.com> <20091102181944.GA4880@nowhere> <1257186583.28925.47.camel@Joe-Laptop.home> <20091102193248.GC4880@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091102193248.GC4880@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Nov 02, 2009 at 10:29:43AM -0800, Joe Perches wrote:
> > On Mon, 2009-11-02 at 19:19 +0100, Frederic Weisbecker wrote:
> > > On Mon, Nov 02, 2009 at 03:26:36PM -0200, André Goddard Rosa wrote:
> > > > Subject: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra check
> > > >    text    data     bss     dec     hex filename
> > > >   15735       0       8   15743    3d7f lib/vsprintf.o-before
> > > >   15719       0       8   15727    3d6f lib/vsprintf.o-minus-double-check
> > > Please add a changelog in your patches, I mean something that
> > > explain your practical change.
> > 
> > Read the subject and try not to go overboard.
> > I think the changelog André provided is perfect.
> 
> 
> It took me some time yesterday to understand how 
> ip6_compressed_string() does its job, hence it took me some time to 
> ensure this patch is safe, hence this reaction for something that 
> didn't seem obvious to me at a first glance.
> 
> But you're right actually, the problem was more in my homework than in 
> the changelog.

Since you wrote the last iteration of that bit and you didnt find it 
trivial i'd strongly suggest the next version of this patch to include a 
more verbose changelog that explains what is being done. There's no harm 
in being verbose about reasons for a change - and there's a lot of harm 
from being too short.

	Ingo
