Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZJWUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZJWUyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZJWUyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:54:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47040 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZJWUyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:54:17 -0400
Date: Fri, 23 Oct 2009 22:54:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091023205400.GA8356@elte.hu>
References: <alpine.LFD.2.00.0910210654480.5125@eeepc.linux-foundation.org> <20091022122042.e535d43c.sfr@canb.auug.org.au> <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256326512.26028.34.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Here's the basic gist, some people believe that linux-next is used as 
> a dumping ground for their repos that get rebased all the time. They 
> use linux-next for early testing, and mostly to make sure their repo 
> will not collide with other developers repos.

I see signs of such an attitude, and i think it's somewhat harmful.

As far as using linux-next for a test-and-rebase workflow - IMO 
maintainer trees should lead with a good example and should not push 
'avoidable crap that might need rebasing' into linux-next (knowingly at 
least - there's enough unintentional damage) that they wouldnt push 
upstream to Linus to begin with.

The pure act of integration testing (the stated primary purpose of 
linux-next) is a large enough of a job in itself IMHO.

Maintainer trees pushed towards linux-next should strive to be Git 
based, append-mostly, 'nice', 'intended for upstream' and defendable 
as-is IMO, and rebasing a _maintainer tree_ should really be a rare act 
of last resort. [ Developers OTOH can (and will and perhaps should) 
rebase frequently until a feature becomes pushable. ]

Anyway - just my two cents - YMMV.

	Ingo
