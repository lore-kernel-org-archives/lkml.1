Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZEDR4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZEDR4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZEDR4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:56:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515AbZEDR4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:56:23 -0400
Date: Mon, 4 May 2009 19:55:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Willy Tarreau <w@1wt.eu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090504175549.GA16720@elte.hu>
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090503053821.GI570@1wt.eu> <49FD3E56.3010803@zytor.com> <200905031308.51316.tobias.doerffel@gmail.com> <20090504131457.GA25844@elte.hu> <20090504063258.00d035b2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504063258.00d035b2@infradead.org>
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

> On Mon, 4 May 2009 15:14:57 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Tobias Doerffel <tobias.doerffel@gmail.com> wrote:
> > 
> > > Am Sonntag, 3. Mai 2009 08:48:54 schrieb H. Peter Anvin:
> > > > Willy Tarreau wrote:
> > > > >> $(call cc-option,-march=atom,-march=i686)
> > > > >
> > > > > if it's an in-order architecture, wouldn't it be better to tune
> > > > > for i386 or i486 instead ?
> > > >
> > > > Possibly.  It would be worth measuring.
> > >
> > > How would one do that (never benchmarked kernel stuff before)?
> > 
> > A standard method is to run lmbench and compare the results - 
> > lmbench has a built-in 'report comparison between two runs' 
> > feature.
> 
> well... you're normally REALLY hard pressed to measure compiler 
> differences this way.....
> 
> normally compiler options get benchmarked using speccpu and the 
> like....

Well, if there's no measurable difference in lmbench at all then the 
options probably dont matter that much. If some workload is found 
where compiler options show a difference then that matters. Speccpu 
only matters if those compiler options also help the kernel, in a 
measurable way.

	Ingo
