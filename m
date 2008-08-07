Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYHGCj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYHGCj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 22:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbYHGCjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 22:39:19 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56534
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbYHGCjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 22:39:18 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 22:39:16 EDT
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] A development process document, V2
Date: Wed, 6 Aug 2008 21:30:39 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Chris Friesen" <cfriesen@nortel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Amanda McPherson <amanda@amcpherson.com>, Jiri Kosina <jkosina@suse.cz>,
       Roland Dreier <rdreier@cisco.com>, Alex Chiang <achiang@hp.com>,
       Jochen =?iso-8859-1?q?Vo=DF?= <jochen.voss@googlemail.com>
References: <20080731111443.2179bf4c@bike.lwn.net> <48921FA5.6060507@nortel.com> <20080804164513.0fcb21dd@bike.lwn.net>
In-Reply-To: <20080804164513.0fcb21dd@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808062130.42021.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 17:45:13 Jonathan Corbet wrote:
> On Thu, 31 Jul 2008 14:25:09 -0600
>
> "Chris Friesen" <cfriesen@nortel.com> wrote:
> > In the documentation section, you might add a link to
> > "http://kernel.org/doc/" since it isn't linked from the main
> > kernel.org page.
>
> I had thought about that.  But the revision log for that page
> (http://landley.net/hg/kdocs) suggests that the last substantive
> changes were made in 2007; it appears to be unmaintained at this
> point.  So I hesitate to add a link to it.  Rob, do you have any plans
> for this page?

Plans?  Yes, plenty.  Time?  Not so far.

I just gave a presentation about how and why I did it at OLS.  (First paper in 
the second volume of 2008 proceedings, which should soon go up at 
http://kernel.org/doc/ols/2008/ols2008v2-pages-7-18.pdf ).  I'm guessing 
that's how Chris found out about it/remembered it?

I meant to make some time to give that site a good once over before my talk, 
but life happened.  (And then I was offline from friday at OLS through 
yesterday.  Plus a server crash while I was out of town.  Fun.)

I'm actually banging on the site a bit right now, I just split up the OLS 2008 
papers, but my "rebuild the website" script is once again dying on the fact 
that "make xmldocs" in the current -git tree dies with some random build 
break du jour.  (Hmmm, revert the kernel it's generating docs from to 2.6.26 
and fix it properly later...)

I would be thrilled to hand the whole thing (mercurial repository and all) off 
to somebody else who could make it #1 on their project list instead of #6 (at 
best) on mine.  Off the top of my head:

1) I'm about to do another Firmware Linux release (as in later today), so 
embedded Linux developers no longer have to cross compile stuff.

2) I'm poking at a new project to build various distros (ubuntu, fedora, 
gentoo, etc) from source, starting from a Linux From Scratch style 
environment (so document what all their incestuous "I only ever compile under 
myself" dependencies actually _are_ and how to provide them).  That's the 
sequel to FWL; use the native development environment to build Ubuntu for sh4 
and so on.

3) I have a dozen things queued up for Toybox.

4) I need to dig up my tinycc fork and extend it to build an unmodified Linux 
kernel.  (Or get llvm+clang to do it, or get the new pcc to do it.  Some 
option other than gcc, and no Intel's closed source x86-only icc doesn't 
count.)

5) I'd like to create a "hello world" Linux kernel that executes the 
appropriate setup code to start running C, and uses the early_printk stuff to 
say hello world out to a serial port, then halt.  (Serious embedded 
developers don't start from a full distro and strip it down, they start from 
an empty directory and add stuff until they have what they want.  Taking 
the "start with everything and strip it down" approach to the Linux kernel 
doesn't really make _sense_ anymore, we need to start with nothing and add 
what we want.)

6) Finish kernel.org/doc.  I have at least a year's worth of work queued up to 
apply to that right now, but working on that isn't my day job anymore, and as 
a hobby it's a bit down the list.

I'll cut a chunk of time out now and try to get it to a good stopping point.  
What it really _needs_ at this point is just cross-referencing all the stuff 
I've already located.  (I was working on doing that with the OLS papers with 
the Linux Foundation pulled the plug.)

(If somebody else wanted to help out with an eye towards taking the whole 
thing over full-time, I'm interested.  But so far, nobody's volunteered...)

> Thanks,
>
> jon

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
