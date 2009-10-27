Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbZJ0Bdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbZJ0Bdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZJ0Bdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:33:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38637
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206AbZJ0Bdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:33:53 -0400
Date: Mon, 26 Oct 2009 18:34:16 -0700 (PDT)
Message-Id: <20091026.183416.52095233.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: sam@ravnborg.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       nico@fluxnic.net, tony.luck@intel.com, sfr@canb.auug.org.au,
       mcgrof@gmail.com, jeff@garzik.org, robert.richter@amd.com,
       dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: David Miller <davem@davemloft.net>
In-Reply-To: <1256603403.26028.358.camel@gandalf.stny.rr.com>
References: <1256601061.26028.350.camel@gandalf.stny.rr.com>
	<20091026.171539.06989895.davem@davemloft.net>
	<1256603403.26028.358.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 26 Oct 2009 20:30:03 -0400

> On Mon, 2009-10-26 at 17:15 -0700, David Miller wrote:
> 
>> What you can't do is _PUBLISH_ this anywhere to a tree that people
>> also do development against _UNTIL_ you get those acks and tested-by
>> tags back from people.
>> 
>> Once your acks etc. come in, you can pop all of those pending patches
>> out of your tree, add the ack tags to the commit messages, then
>> reapply them.
>> 
>> Then you can push to your public tree, but no sooner.
>> 
>> It really is that simple.
> 
> But you never answered my question? How long do you let it cook? I don't
> have regular people that test my patches and pass tested by, whatever. I
> get them here and there, sometimes I even a reviewed by.  Most of the
> time I just get silence.

1 day, maybe 2 or even 3 depending upon the type of change and the
travel schedules of core developers.  On the networking lists things
get tested and reviewed quite quickly.

> My testing is mostly done in Ingo's test suite, and that happens after I
> do my push to him. This works best for me.

So you both should keep your trees private until it's all sorted out
and you have the results in hand.

Nobody forces you guys to use public trees just to run Ingo's personal
test suite, you have decided to work that way.  And that is therefore
something you guys can change without effecting other people.

> If I had to publish and let cook on LKML, then I would also need to keep
> better accounting of what I have pushed out and what I have left to do.

The problem isn't that you have to push patches out and only work
with patches, the problem is that you want to use publicly visible
GIT trees to do your testing at all times.

And sorry, that is not how you're supposed to do things.
