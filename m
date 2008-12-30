Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbYL3G2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbYL3G2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYL3G2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:28:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36233 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYL3G2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:28:30 -0500
Date: Tue, 30 Dec 2008 07:28:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nathan Lynch <ntl@pobox.com>
Cc: Sebastien Dugue <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Gilles Carry <Gilles.Carry@ext.bull.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC][PATCH] Fix cpu hotplug hang
Message-ID: <20081230062812.GA30975@elte.hu>
References: <20081201140907.56743abd@bull.net> <20081215123128.172b21be@bull.net> <20081230001729.GD6958@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230001729.GD6958@localdomain>
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


* Nathan Lynch <ntl@pobox.com> wrote:

> Sebastien Dugue wrote:
> > On Mon, 1 Dec 2008 14:09:07 +0100 Sebastien Dugue <sebastien.dugue@bull.net> wrote:
> > 
> > > 
> > >   here is a patch that fixes a CPU hotplug hang I get on a Power6
> > > box. It may not be the only possible fix but it appears to be the
> > > cleanest I can think of at the moment.
> > > 
> > >   Comments welcomed.
> > 
> >   Ingo, Thomas, anybody care to comment on the hang and this possible fix?
> 
> FWIW, I was able to recreate this hang with 2.6.28 on a 8-way Power5 
> system, and Sebastien's patch does appear to fix the problem for my 
> testcase, which does a few hundred offline/online operations.

i've applied Sebastien's patch to tip/timers/hrtimers. Good catch! I've 
also tagged it for a -stable backport.

	Ingo
