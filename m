Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbXHAWvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbXHAWvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXHAWvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:51:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44387 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXHAWvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:51:22 -0400
Date: Thu, 2 Aug 2007 04:33:46 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Christopher Hoover <ch@murgatroid.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <loom.20070802T000504-963@post.gmane.org>
Message-ID: <alpine.LFD.0.999.0708020421310.8258@enigma.security.iitk.ac.in>
References: <1185288769.14697.339.camel@pmac.infradead.org>
 <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com>
 <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
 <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
 <20070729095040.GZ9840@enneenne.com> <alpine.LFD.0.999.0707301033180.10861@enigma.security.iitk.ac.in>
 <20070730085157.GE9840@enneenne.com> <alpine.LFD.0.999.0707301438190.13448@enigma.security.iitk.ac.in>
 <loom.20070802T000504-963@post.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, 1 Aug 2007, Christopher Hoover wrote:

> Satyam Sharma <satyam <at> infradead.org> writes:
> > On Mon, 30 Jul 2007, Rodolfo Giometti wrote:
> > 
> > > On Mon, Jul 30, 2007 at 10:33:35AM +0530, Satyam Sharma wrote:
> > > Currently the RFC says to you that you should open the serial port:
> > > 
> > > 	fd = open("/dev/ttyS0", ...);
> > 
> > No, it does *NOT*. All it says is:
> > 
> >     The time_pps_create() is used to convert an already-open UNIX file
> >     descriptor, for an appropriate special file, into a PPS handle.
> > 
> > See? What I said is precisely the implementation the RFC envisages
> > (and the only sane way to implement it too).
> 
> If we were totally rigurous about representing each device as a device node, 
> your solution would be fine.  But we don't.

Of course.

> The clocksource model (/sys/devices/system/clocksource) is a better way to 
> go.  One sysfs file is used to enumerate the possible sources and another is 
> used to read or set the current source.   No new system calls; no new ioctls.

Oh, not introducing any syscalls _at all_ would be fine, too. But the
RFC does /require/ an implementation to have them. I was only mentioning
the kind of implementation the RFC had in mind. But there are other ways
to achieve the same end goal, and yes, probably it's better to avoid
introducing syscalls in the first place and think of other mechanisms.

[ It's not that we're talking of IPsec or IPv6 or something here --
  so RFC-compliance isn't overly important. But the final result
  needs to be good, secure and well-designed, still. ]


Satyam
