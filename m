Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYHYJT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYHYJT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYHYJSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:18:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414AbYHYJSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:18:13 -0400
Date: Mon, 25 Aug 2008 11:17:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Joshua Hoblitt <josh@hoblitt.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080825091747.GE9114@elte.hu>
References: <20080822010014.GH23377@hoblitt.com> <20080822011055.GI23377@hoblitt.com> <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com> <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com> <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com> <20080822035024.GB30284@elte.hu> <86802c440808212316t1c89321fl717fa80d2013f155@mail.gmail.com> <20080822062459.GO14110@elte.hu> <20080823165318.50ae9d8c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080823165318.50ae9d8c@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 22 Aug 2008 08:24:59 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > 
> > > > +               if (tmp != mask_lo) {
> > > > +                       WARN_ON("mtrr: your BIOS has set up an
> > > > incorrect mask, fixing it up.\n");
> > > 
> > > can you change WARN_ON to WARN_ON_ONCE ?
> > 
> > the commit below does that. Note that the condition is 
> > WARN_ON(condition) or WARN(string) - WARN_ON(string) will just print
> > a kernel stack unconditionally. Unfortunately there's no WARN_ONCE(). 
> > (Arjan?)
> 
> Andrew removed that from the patches as "unused" :-(
> oh well easy to add back ;-)

please send a patch, with at least one user :-)

	Ingo
