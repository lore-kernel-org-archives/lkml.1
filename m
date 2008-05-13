Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbYEMRSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbYEMRSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYEMRR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:17:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55692 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYEMRR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:17:57 -0400
Date: Tue, 13 May 2008 19:17:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Latest Linus git: =?utf-8?Q?kernel=2Fs?=
	=?utf-8?B?Y2hlZC5jOjEyMTY6IHdhcm5pbmc6IOKAmGluaXRfaHJ0aWNr?=
	=?utf-8?B?4oCZ?= defined but not used
Message-ID: <20080513171734.GA6792@elte.hu>
References: <48278762.1080508@gmail.com> <20080513132328.GB5809@elte.hu> <20080513153403.GA4474@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513153403.GA4474@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0035]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> > > I could write up the simple patch to put #ifdef CONFIG_SMP around 
> > > init_hrtick(), but with all of the #ifdefs in that file, I figure 
> > > it is probably a little more complicated than that.
> > 
> > the fix seems simple - see below. The #ifdef jungle ... less so.
> 
> I attempted to make it a bit easier to figure out that jungle at 
> http://lkml.org/lkml/2008/5/12/64 , if it helps.

yeah, applied it - it definitely helps. Would be better to hide most of 
these complications in include files though.

	Ingo
