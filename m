Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXBPRrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXBPRrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626AbXBPRrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:47:23 -0500
Received: from h190.mvista.com ([63.81.120.158]:48533 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbXBPRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:47:22 -0500
Subject: Re: Using sched_clock for mmio-trace
From: Daniel Walker <dwalker@mvista.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jeff Muizelaar <jeff@infidigm.net>, linux-kernel@vger.kernel.org
In-Reply-To: <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
References: <20070216013024.GA32287@infidigm.net>
	 <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 09:45:21 -0800
Message-Id: <1171647921.3422.12.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 11:30 -0500, Frank Ch. Eigler wrote:
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
> 
> > [...]  The question is, what [timer] api should I be using? I need
> > something that can be called from inside interrupt handlers, and
> > obviously the more accurate and the lower the overhead the better.
> 
> We in systemtap land have the same problem, and so far made do with
> slightly postprocessed per-cpu TSC values.

I've been working on a patch set (below), to expose the clocksources
used by generic time to multiple users . It would allow timestamps from
different clocks in a generic way. It's not merged, but I'd appreciate
any input either of you might have..

ftp://source.mvista.com/pub/dwalker/clocksource/

Daniel

