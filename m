Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZJFRJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZJFRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbZJFRJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:09:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57216 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbZJFRJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:09:55 -0400
Date: Tue, 6 Oct 2009 19:08:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006170846.GA9277@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <4ACB626C.8090503@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACB626C.8090503@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0177]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Ingo Molnar wrote:
> > I.e. i think it's a fact that right now our release version is highly 
> > deceptive during the merge window.
> [...]
> > One option would be to make LOCALVERSION_AUTO compulsory.
> > 
> > Or to add a tweak to the naming, something like:
> > 
> >  v2.6.31
> >  v2.6.31+
> >  v2.6.32-rc1
> >  v2.6.32-rc1+
> [...]
> > ... for the sole purpose of warning people that anything they pull after 
> > v2.6.31 got released is (wildly!) not vanilla v2.6.31 anymore.
> 
> If this scheme is meant to be something on which people can rely on, 
> everybody who commits to a tree from which Linus pulls from would have 
> to base their branches onto those ...+ commits, always.

I think you misunderstood - the + would just be a shortcut for the 
long-form precise version string.

	Ingo
