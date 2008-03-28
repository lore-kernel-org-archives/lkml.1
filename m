Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYC1OOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYC1OOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYC1OOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:14:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57388 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbYC1ON7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:13:59 -0400
Date: Fri, 28 Mar 2008 15:13:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: when telling user you'll corrupt his data, at least
	do it at KERN_CRIT
Message-ID: <20080328141348.GE29218@elte.hu>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113528.GA8077@elte.hu> <20080328134451.GB4544@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328134451.GB4544@ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2008-03-28 12:35:28, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > IOMMU off means very bad stuff may happen, like data corruption on 
> > > your hard drives. At least tells users this is serious...
> > 
> > ouch. Please at minimum lets turn this into a panic(), but best would be 
> > to trim memory in this case, hm?
> 
> Andi tells me we already fallback to swiotlb, so messages are not on 
> wrong loglevel; they contain confusing/obsolete text.

yes that is the theory - but how did your disk get corrupted in 
practice? ;-)

	Ingo
