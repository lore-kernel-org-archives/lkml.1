Return-Path: <linux-kernel-owner+w=401wt.eu-S1946195AbXBPS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946195AbXBPS3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946196AbXBPS3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:29:19 -0500
Received: from gamma2.look.ca ([207.136.100.4]:58796 "EHLO gatekeeper.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946195AbXBPS3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:29:18 -0500
Date: Fri, 16 Feb 2007 13:30:14 -0500
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070216183014.GD6425@infidigm.net>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: Re: Using sched_clock for mmio-trace
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 11:30:56AM -0500, Frank Ch. Eigler wrote:
> Jeff Muizelaar <jeff@infidigm.net> writes:
> 
> > I've built a tool with the goal of logging mmio writes and reads by
> > device drivers. See http://nouveau.freedesktop.org/wiki/MmioTrace.
> 
> FWIW, this is exactly a type of add-on trace patch that could be
> mooted by adoption of the ltt/systemtap "marker" facility.  With it,
> you would not need so much code (e.g. no new user-space tools at all,
> reuse of common tracing buffer logic, permanently placed hooks) and
> would probably get more utility.

Is there more information on this "marker" facility? e.g. what is a
marker? Are they just like tracepoints?

> > [...]  The question is, what [timer] api should I be using? I need
> > something that can be called from inside interrupt handlers, and
> > obviously the more accurate and the lower the overhead the better.
> 
> We in systemtap land have the same problem, and so far made do with
> slightly postprocessed per-cpu TSC values.

Thanks, I'll have a look at systemtap does. It's the stuff
src/runtime/time.c right?

Also, you might want to move this stuff from the README to someplace
more prominent on the systemtap website. It's nice not to have to dig
far to get the source...

Download systemtap sources snapshot or from CVS:
ftp://sources.redhat.com/pub/systemtap/snapshots/ 
(or)
cvs -d :pserver:anoncvs@sources.redhat.com:/cvs/systemtap login
# enter "anoncvs" as the password
cvs -d :pserver:anoncvs@sources.redhat.com:/cvs/systemtap co src

-Jeff
