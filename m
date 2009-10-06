Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbZJFOqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbZJFOqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbZJFOqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:46:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbZJFOqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:46:23 -0400
Date: Tue, 6 Oct 2009 16:44:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006144449.GA23078@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So no. I'm not going to do -rc0. Because doing that is _stupid_. And 
> until you understand _why_ it's stupid, it's pointless talking about 
> it, and when you _do_ understand that it's stupid, you'll agree with 
> me.

I understand non-linear history, but still i think that it might make 
sense to make it more apparent that the tree people pull from you after 
.31 got released is a lot closer to what .32 is going to be than to .31. 
(which the name implies)

I.e. i think it's a fact that right now our release version is highly 
deceptive during the merge window. Two days into the merge window and we 
have more commits added than we add from .31-rc7 to .31-rc9 total. A 
week into the merge window we have .31 + 6000 commits merged and still 
call it v2.6.31, to the casual looker.

We can ignore that and say "hehe, you dont understand non-linear trees 
and ran git remote update blindly, too bad for you", or we might do 
something to make things more transparent and reduce the confusion. 
Personally i really want people to try our git trees, but them also be 
fully aware of the risks involved.

One option would be to make LOCALVERSION_AUTO compulsory.

Or to add a tweak to the naming, something like:

 v2.6.31
 v2.6.31+
 v2.6.32-rc1
 v2.6.32-rc1+
 ..
 v2.6.32-rc9
 v2.6.32-rc9+
 v2.6.32

Would make it clear what's going on, even in the simplified world of 
limited-size version numbers.

Or, IMHO it would also be a valid naming model to do this small tweak to 
the above naming scheme:

 v2.6.31
 v2.6.32-rc0
 v2.6.32-rc0+
 v2.6.32-rc1
 v2.6.32-rc1+
 ..
 v2.6.32-rc9
 v2.6.32-rc9+
 v2.6.32

... for the sole purpose of warning people that anything they pull after 
v2.6.31 got released is (wildly!) not vanilla v2.6.31 anymore. Not more, 
not less.

Am i confused? :-)

	Ingo
