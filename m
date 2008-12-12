Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbYLLLHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbYLLLHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYLLLHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:07:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105AbYLLLHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:07:01 -0500
Date: Fri, 12 Dec 2008 12:06:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: document CFS behavior
Message-ID: <20081212110645.GE32640@elte.hu>
References: <20081208215221.GA3954@us.ibm.com> <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org> <20081209024543.GA11538@elte.hu> <alpine.LRH.1.10.0812092005100.10841@tundra.namei.org> <20081209100817.GA11886@elte.hu> <alpine.LRH.1.10.0812092114140.11867@tundra.namei.org> <20081209161620.GC9487@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209161620.GC9487@us.ibm.com>
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


* Serge E. Hallyn <serue@us.ibm.com> wrote:

> Quoting James Morris (jmorris@namei.org):
> > On Tue, 9 Dec 2008, Ingo Molnar wrote:
> > 
> > > > They're already published in my tree.  Do you want me to revert them?
> > > 
> > > I've also got it published :-/ If it's at the tail of your commits, can 
> > > you reset it?
> > 
> > There have been commits since, and people are using the tree in any case.
> 
> Yikes.  Maybe it's best (henceforth) to keep user namespaces patches in 
> their own tree toward the end of linux-next?  There certainly are 
> security implications with all of them, but other things (filesystem, 
> sched) will be impacted as well...

i'm fine with having this in James's tree - i didnt realize that you had 
another commit that created dependencies.

(if such situations ever cause real damage then we can always create a 
separate branch to track it cleanly. That's not needed now.)

	Ingo
