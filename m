Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZJ0B3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZJ0B3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZJ0B3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:29:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36013 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbZJ0B3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:29:32 -0400
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       nico@fluxnic.net, tony.luck@intel.com, sfr@canb.auug.org.au,
       mcgrof@gmail.com, jeff@garzik.org, robert.richter@amd.com,
       dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
In-Reply-To: <20091026.171539.06989895.davem@davemloft.net>
References: <1256599588.26028.340.camel@gandalf.stny.rr.com>
	 <20091026.163050.156983266.davem@davemloft.net>
	 <1256601061.26028.350.camel@gandalf.stny.rr.com>
	 <20091026.171539.06989895.davem@davemloft.net>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 20:30:03 -0400
Message-Id: <1256603403.26028.358.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 17:15 -0700, David Miller wrote:

> What you can't do is _PUBLISH_ this anywhere to a tree that people
> also do development against _UNTIL_ you get those acks and tested-by
> tags back from people.
> 
> Once your acks etc. come in, you can pop all of those pending patches
> out of your tree, add the ack tags to the commit messages, then
> reapply them.
> 
> Then you can push to your public tree, but no sooner.
> 
> It really is that simple.

But you never answered my question? How long do you let it cook? I don't
have regular people that test my patches and pass tested by, whatever. I
get them here and there, sometimes I even a reviewed by.  Most of the
time I just get silence.

My testing is mostly done in Ingo's test suite, and that happens after I
do my push to him. This works best for me.

Perhaps this doesn't bother your work flow, but it does mine. 90% (or
more) of the bugs in my code is found in Ingo's test suites. This means
I want to get it to him ASAP, and I do so by pushing it to him and
Cc'ing LKML. Then I can work on my next set of patches without worrying
about the last set I sent.

If I had to publish and let cook on LKML, then I would also need to keep
better accounting of what I have pushed out and what I have left to do.
My wife does the bills because I can't do accounting for crap. If I need
to account for patches that have been to LKML, and time them to know
when to push into some tree, I'm just destine to let a few patches slip
through the cracks.

-- Steve


