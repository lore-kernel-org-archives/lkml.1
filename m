Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYHOT5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYHOT5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYHOT5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:57:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYHOT5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:57:41 -0400
Date: Fri, 15 Aug 2008 21:57:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Greg KH <greg@kroah.com>, Pavel Machek <pavel@suse.cz>,
       "Deguara, Joachim" <joachim.deguara@amd.com>, gregkh@ucw.cz,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01][retry 5] x86: L3 cache index disable for 2.6.26
Message-ID: <20080815195712.GC25185@elte.hu>
References: <200807181603.52332.mark.langsdorf@amd.com> <200808141148.38108.mark.langsdorf@amd.com> <20080814171042.GA26985@kroah.com> <200808141332.53538.mark.langsdorf@amd.com> <20080815164213.GA29956@elte.hu> <6453C3CB8E2B3646B0D020C112613273C5AC78@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC78@sausexmb4.amd.com>
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


* Langsdorf, Mark <mark.langsdorf@amd.com> wrote:

> > > This patch does not set an automatic policy to disable
> > > the L3 cache.  Policy decisions would need to be made
> > > by a RAS handler.  This patch merely makes it easier to
> > > see what indices are currently disabled.
> > 
> > hm, looks good - but since i've got an earlier version of 
> > this included 
> > in -tip already:
> > 
> >  commit a24e8d36f5fc047dac9af6200322ed393f2e3175
> >  Author: Mark Langsdorf <mark.langsdorf@amd.com>
> >  Date:   Tue Jul 22 13:06:02 2008 -0500
> > 
> >     x86: L3 cache index disable for 2.6.26
> > 
> > could you please send a delta patch against tip/master?
> > 
> >    http://people.redhat.com/mingo/tip.git/README
> 
> tip/master looks likes it has the version 5 of my patch
> in it already.  Am I missing something?

ok, that's good - that's the latest, right?

	Ingo
