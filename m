Return-Path: <linux-kernel-owner+w=401wt.eu-S1946213AbXBPSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946213AbXBPSsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946216AbXBPSsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:48:51 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:63257 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946213AbXBPSsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:48:50 -0500
Date: Fri, 16 Feb 2007 10:44:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Muizelaar <jeff@infidigm.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Using sched_clock for mmio-trace
Message-Id: <20070216104415.bca20c4b.randy.dunlap@oracle.com>
In-Reply-To: <20070216183014.GD6425@infidigm.net>
References: <20070216013024.GA32287@infidigm.net>
	<y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
	<20070216183014.GD6425@infidigm.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 13:30:14 -0500 Jeff Muizelaar wrote:

> On Fri, Feb 16, 2007 at 11:30:56AM -0500, Frank Ch. Eigler wrote:
> > Jeff Muizelaar <jeff@infidigm.net> writes:
> > 
> > > I've built a tool with the goal of logging mmio writes and reads by
> > > device drivers. See http://nouveau.freedesktop.org/wiki/MmioTrace.
> > 
> > FWIW, this is exactly a type of add-on trace patch that could be
> > mooted by adoption of the ltt/systemtap "marker" facility.  With it,
> > you would not need so much code (e.g. no new user-space tools at all,
> > reuse of common tracing buffer logic, permanently placed hooks) and
> > would probably get more utility.
> 
> Is there more information on this "marker" facility? e.g. what is a
> marker? Are they just like tracepoints?

On lkml for the past few days/months.
Look for "Linux Kernel Markers" in the subject line.

Mathieu, do you have a web site for LK Markers?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
