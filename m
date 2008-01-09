Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYAIBXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYAIBXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYAIBXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:23:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57468 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbYAIBXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:23:10 -0500
Date: Wed, 9 Jan 2008 02:22:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109012257.GB1133@elte.hu>
References: <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <20080109004329.GA6603@elte.hu> <47841EB1.1020304@goop.org> <20080109011609.GB29807@elte.hu> <20080109011846.GE25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109011846.GE25945@bingen.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> On Wed, Jan 09, 2008 at 02:16:09AM +0100, Ingo Molnar wrote:
> > 
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> > > This isn't correct, because it will set _PAGE_GLOBAL on 32-bit 
> > > unconditionally.  It needs to be something like:
> > 
> > hm, why is that a problem?
> 
> Not so ancient 32bit CPUs didn't support global.

'not so ancient' like: pre-PPro ones? But we mark the ptes PAGE_GLOBAL 
during pagetable init so we should be fine performance-wise.

but yeah, it shouldnt be turned on unconditionally indeed.

	Ingo
