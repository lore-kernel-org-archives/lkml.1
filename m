Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZJGPKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZJGPKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZJGPKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:10:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZJGPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:10:33 -0400
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Andy Whitcroft <apw@canonical.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1254925617.18167.262.camel@desktop>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	 <1254406711.18167.88.camel@desktop> <m33a5ww8kn.fsf@intrepid.localdomain>
	 <1254887534.18167.253.camel@desktop>  <m3hbubv779.fsf@intrepid.localdomain>
	 <1254925617.18167.262.camel@desktop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 11:08:34 -0400
Message-Id: <1254928114.1696.164.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 07:26 -0700, Daniel Walker wrote:
> On Wed, 2009-10-07 at 12:17 +0200, Krzysztof Halasa wrote:
> > Daniel Walker <dwalker@fifo99.com> writes:
> > 
> > > This thread is specifically about checkpatch errors .. checkpatch
> > > warnings can be ignored, but errors you can't usually ignore..
> > 
> > Of course I can and do :-)
> > 
> > > If your
> > > ignoring errors then either checkpatch is producing bogus output that
> > > needs to be corrected, or it's something you really should fix..
> > 
> > Neither.
> > But unfortunately I don't have examples handy.
> > 
> > My POV must be a bit different: I treat errors like another class of
> > warnings (perhaps more important that "mere" warnings but still not
> > authoritative).
> 
> >From my perspective Documentation/SubmittingPatches really dictates what
> you should be doing with checkpatch, since that was signed off on by
> Andy (on this thread) and Linus .. In that document I think checkpatch
> is given authority, rather than what your suggesting where it's just
> something you can use or not, and ignore or not like it has no meaning
> at all..

Daniel,

This is getting old. You've successfully entered the /dev/null folder to
several major developers.

The checkpatch.pl script is a very useful tool. I run it on all my
patches to make sure that I don't have any silly formatting errors. It
even catches some real bugs now and then.

That said, if we really wanted to have checkpatch as a authoritative
tool, it would be executed by a bot on all patches submitted to LKML
(which you seem to have put on yourself to do). But if Linus or others
wanted that, they would have set it up.

We assume that the maintainers of the system are competent enough to
keep a decent formatting style that conforms to the rest of the kernel.
There are some instances that the style may change to cover cases that
are unique, like the events headers.

Really it should be up to the maintainer to tell a submitter that they
need to run checkpatch. You are coming out as the checkpatch Nazi leader
to "enforce" your will of the tool on others. And when they tell you,
it's not that big of a deal, you have a conniption.

So my advice to you is to take a chill pill (they come in chewables) and
relax a bit on this topic. If you had just sent out some nice emails to
obvious breakage in patches, then it would have been fine. But you are
coming across a bit too authoritarian, and it is becoming quite
annoying.

-- Steve


