Return-Path: <linux-kernel-owner+w=401wt.eu-S1031191AbXD1Tiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031191AbXD1Tiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031200AbXD1Tiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:38:51 -0400
Received: from dvhart.com ([64.146.134.43]:42600 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031191AbXD1Tit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:38:49 -0400
X-Greylist: delayed 1790 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 15:38:49 EDT
Message-ID: <46339BC7.6050802@mbligh.org>
Date: Sat, 28 Apr 2007 12:08:55 -0700
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The thing is, these reports MUST NOT go to "everybody". If they do, that 
> is actually *worse* than nothing, because people will just ignore them 
> entirely, since they aren't "directed".
> 
> The emails need to be directed to the appropriate parties, not go to 
> everybody. There is nobody who is interested in seeing all regressions, 
> except perhaps me and Andrew. Most *real* developers (as opposed to people 
> like me, who are integrators, not "real developers") want to be notified 
> about problems in *their* area, and if it's just automation that sends out 
> everything, it just dilutes the value of the thing, to the point where 
> people will ignore it even for the cases when they happen to be related to 
> what they do.

It's easy to send the different categories to different mailing lists,
if that's what we want to do. Apart from some aggressive filtering on
the SCSI lists etc stops me from bouncing messages to it, but that's
fixable.

Yes, human involvement from someone with half a brain would be better.
Andrew does a lot of that. Not a particularly good use of talent really.
but still.

As Andrew has pointed out before though - even though he forwards
the bugs, nobody does anything with it. The sad truth seems to be
that people have very little interest in fixing bugs when they are
reported - it's not sexy, I guess.

> Let me put it another way: I would never use a source control system that 
> forces me to look at my 22,000 files one at a time. I think such a system 
> is fundamentally broken, because it makes it impossible to get the big 
> picture ("what changed in the last week" kind of thing). The same is true 
> of bugzilla: if you *know* which bug you're looking at, it's good. For 
> anythign else, it's almost worse than useless, exactly because there is no 
> way to get an overview

Go to http://bugzilla.kernel.org. Hit query. Find the box that says
"Bug Changes, Only bugs changed in the last __ days". Stick 7 in it.

74 bugs found.

Not hard to do.

> (I've said this before, but I'll say it again: one thing that would 
> already make bugzilla better is to just always drop any bug reports that 
> are more than a week old and haven't been touched. It wouldn't need *much* 
> touching, but if a reporter cannot be bothered to say "still true with 
> current snapshot" once a week, then it shouldn't be seen as being somehow 
> up to those scare resources we call "developers" to have to go through 
> it).

I'm reluctant to drop / close them. We could fairly easily move them to
a "STALE" state if you want, and have that ping the user. Not sure what
we'd ping them with apart from "Nobody seems to give a toss about your
bug. Life's a bitch. Try sending chocolates, flowers, or fireworks".
I'm still unconvinced the users or the tool are the problem, but if it
makes you happier, we can do that.

> So there are probably things that bugzilla could do to become more useful, 
> but I don't see that happening. We'd need either a smarter/better 
> bugzilla, or somebody who actually turns noise into real information. 
> Adrian did that (although in fairness to others, other people definitely 
> do it too. Dave Jones, for example. Very useful).

What would you want from a smarter / better bugzilla or other bug
tracking tool? A list of requirements / suggestions would be nice. The
main complaint we had before was lack of an email interface, and that
was fixed a long time ago. I admit development has not exactly been
active since, but the only person I got real feedback from was Dave J,
and we've been fixing his UI issues.

M.
