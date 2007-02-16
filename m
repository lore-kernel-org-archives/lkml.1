Return-Path: <linux-kernel-owner+w=401wt.eu-S1946092AbXBPTy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946092AbXBPTy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946093AbXBPTy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:54:27 -0500
Received: from beta2.look.ca ([207.136.100.3]:45930 "EHLO twiddle.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946092AbXBPTy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:54:26 -0500
Date: Fri, 16 Feb 2007 14:55:20 -0500
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <20070216195520.GG6425@infidigm.net>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <20070216183014.GD6425@infidigm.net> <20070216104415.bca20c4b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20070216104415.bca20c4b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: Re: Using sched_clock for mmio-trace
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 10:44:15AM -0800, Randy Dunlap wrote:
> On Fri, 16 Feb 2007 13:30:14 -0500 Jeff Muizelaar wrote:
> 
> > On Fri, Feb 16, 2007 at 11:30:56AM -0500, Frank Ch. Eigler wrote:
> > > Jeff Muizelaar <jeff@infidigm.net> writes:
> > > 
> > > > I've built a tool with the goal of logging mmio writes and reads by
> > > > device drivers. See http://nouveau.freedesktop.org/wiki/MmioTrace.
> > > 
> > > FWIW, this is exactly a type of add-on trace patch that could be
> > > mooted by adoption of the ltt/systemtap "marker" facility.  With it,
> > > you would not need so much code (e.g. no new user-space tools at all,
> > > reuse of common tracing buffer logic, permanently placed hooks) and
> > > would probably get more utility.
> > 
> > Is there more information on this "marker" facility? e.g. what is a
> > marker? Are they just like tracepoints?
> 
> On lkml for the past few days/months.
> Look for "Linux Kernel Markers" in the subject line.
> 
> Mathieu, do you have a web site for LK Markers?
> 

Yeah, so if I understand correctly, markers are basically compile time locations
that you can attach function calls to at run time, right?. If so, I
don't think they are of much use to me.

What I am doing is page-faulting on every read or write to an mmio
region, decoding the faulting instruction and passing the decoded
information up to userspace through relayfs.

-Jeff
