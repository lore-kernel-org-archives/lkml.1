Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZJ0APS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZJ0APS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZJ0APR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:15:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47010
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbZJ0APQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:15:16 -0400
Date: Mon, 26 Oct 2009 17:15:39 -0700 (PDT)
Message-Id: <20091026.171539.06989895.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: sam@ravnborg.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       nico@fluxnic.net, tony.luck@intel.com, sfr@canb.auug.org.au,
       mcgrof@gmail.com, jeff@garzik.org, robert.richter@amd.com,
       dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: David Miller <davem@davemloft.net>
In-Reply-To: <1256601061.26028.350.camel@gandalf.stny.rr.com>
References: <1256599588.26028.340.camel@gandalf.stny.rr.com>
	<20091026.163050.156983266.davem@davemloft.net>
	<1256601061.26028.350.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 26 Oct 2009 19:51:01 -0400

> On Mon, 2009-10-26 at 16:30 -0700, David Miller wrote:
>> From: Steven Rostedt <rostedt@goodmis.org>
>> Date: Mon, 26 Oct 2009 19:26:28 -0400
>> 
>> > I think this is more of a failure in git than in the work flow we
>> > present.
>> 
>> Others (like me) will say you should have let that patch cook for a
>> while on the mailing list or in your tree before publishing, in order
>> to let those acks and tested-by replies come in.
>> 
>> That's how I handle this.
>> 
>> And I really don't buy the argument that you have to publish the
>> change in a GIT tree to get those ACKs and tested-by replies.
> 
> The thing is, I do my changes with git.

So do I.

> I get something working and then commit it. Then I do more changes
> and commit that. I don't use quilt anymore for this.

And you can do this all day long if you like.

What you can't do is _PUBLISH_ this anywhere to a tree that people
also do development against _UNTIL_ you get those acks and tested-by
tags back from people.

Once your acks etc. come in, you can pop all of those pending patches
out of your tree, add the ack tags to the commit messages, then
reapply them.

Then you can push to your public tree, but no sooner.

It really is that simple.
