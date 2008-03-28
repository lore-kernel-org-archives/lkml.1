Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYC1Mwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYC1Mwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbYC1Mvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:51:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbYC1Mve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:51:34 -0400
Date: Fri, 28 Mar 2008 13:51:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: when telling user you'll corrupt his data, at least
	do it at KERN_CRIT
Message-ID: <20080328125121.GB20426@elte.hu>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113528.GA8077@elte.hu> <Pine.LNX.4.64.0803281347210.32241@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803281347210.32241@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 28 Mar 2008, Ingo Molnar wrote:
> 
> > > IOMMU off means very bad stuff may happen, like data corruption on 
> > > your hard drives. At least tells users this is serious...
> > ouch. Please at minimum lets turn this into a panic(), but best would be 
> > to trim memory in this case, hm?
> 
> Are you suggesting to panic on all 64bit machines having more than 4G 
> RAM without IOMMU turned on? Why, if swiotlb can still work nicely in 
> such situations?

no, but we should avoid Pavel's disk corruption scenario ;-)

	Ingo
