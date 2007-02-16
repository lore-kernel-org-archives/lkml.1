Return-Path: <linux-kernel-owner+w=401wt.eu-S1946035AbXBPSbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946035AbXBPSbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946199AbXBPSbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:31:15 -0500
Received: from h190.mvista.com ([63.81.120.158]:61317 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1946035AbXBPSbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:31:14 -0500
Subject: Re: Using sched_clock for mmio-trace
From: Daniel Walker <dwalker@mvista.com>
To: Jeff Muizelaar <jeff@infidigm.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070216181027.GC6425@infidigm.net>
References: <20070216013024.GA32287@infidigm.net>
	 <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
	 <1171647921.3422.12.camel@imap.mvista.com>
	 <20070216181027.GC6425@infidigm.net>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 10:28:50 -0800
Message-Id: <1171650530.3422.25.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 13:10 -0500, Jeff Muizelaar wrote:
> On Fri, Feb 16, 2007 at 09:45:21AM -0800, Daniel Walker wrote:
> > I've been working on a patch set (below), to expose the clocksources
> > used by generic time to multiple users . It would allow timestamps from
> > different clocks in a generic way. It's not merged, but I'd appreciate
> > any input either of you might have..
> > 
> > ftp://source.mvista.com/pub/dwalker/clocksource/
> 
> Is it possible to see the resulting clocksource.h and maybe
> clocksource.c after the patch set? That would make looking at it much
> easier.

Well you could just apply the patch set, but I stuck them in the same
directory as above .. I'll delete them in 24 hours or so ..

At one point I replaced sched_clock() , 

ftp://source.mvista.com/pub/dwalker/clocksource/clocksource-v10/add_generic_sched_clock.patch

The API is similar to that version, and sched_clock was the simplest
user of the API that I've done.

Daniel

