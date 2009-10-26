Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZJZXvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZJZXvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZJZXvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:51:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbZJZXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:51:14 -0400
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       nico@fluxnic.net, tony.luck@intel.com, sfr@canb.auug.org.au,
       mcgrof@gmail.com, jeff@garzik.org, robert.richter@amd.com,
       dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
In-Reply-To: <20091026.163050.156983266.davem@davemloft.net>
References: <20091023205400.GA8356@elte.hu>
	 <20091023215958.GA4139@merkur.ravnborg.org>
	 <1256599588.26028.340.camel@gandalf.stny.rr.com>
	 <20091026.163050.156983266.davem@davemloft.net>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 19:51:01 -0400
Message-Id: <1256601061.26028.350.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 16:30 -0700, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 26 Oct 2009 19:26:28 -0400
> 
> > I think this is more of a failure in git than in the work flow we
> > present.
> 
> Others (like me) will say you should have let that patch cook for a
> while on the mailing list or in your tree before publishing, in order
> to let those acks and tested-by replies come in.
> 
> That's how I handle this.
> 
> And I really don't buy the argument that you have to publish the
> change in a GIT tree to get those ACKs and tested-by replies.

The thing is, I do my changes with git. I get something working and then
commit it. Then I do more changes and commit that. I don't use quilt
anymore for this.

Then I have an automated process to send out those patches. Heck pushing
it to git makes it _easier_ to do testing. Instead of having someone
pull out 5 or so patches from LKML, they can just pull my git repo and
start testing it.

Yes, I could let it cook on LKML, but I don't have the test suite that
Ingo has either. I do my own set of tests, then I push it out and let
Ingo run it through his test suite.

Some patches get tested by others, some don't. I don't formally ask
anyone to test them besides Ingo. But it is nice to know that someone
tested it, and sometimes I even get people to review it.

So what's the time to leave it out on LKML before pulling it into git?
(which it is already in git for me anyway). I could wait a week, two?
And after pulling it in after this time, I may still get a late
"tested-by" or "reviewed-by".

I think if people knew that they could test or review patches that are
already in git and get acknowledged for doing so, there may be more
people who will test and review patches. Heck, if someone was board,
they could go and review patches already in Linus's tree. I don't think
it would become a new haven for those that want fame, since placing a
tag on a commit is also placing your reputation there too.

-- Steve


