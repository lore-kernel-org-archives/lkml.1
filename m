Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbYDNSXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbYDNSXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbYDNSUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:20:48 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:36537 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933077AbYDNSUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:20:47 -0400
Date: Mon, 14 Apr 2008 21:20:21 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] mmiotrace: add user documentation
Message-ID: <20080414212021.5d2c351c@daedalus.pq.iki.fi>
In-Reply-To: <Pine.LNX.4.58.0804141144500.9886@gandalf.stny.rr.com>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
	<20080413224859.4e3f5ddb@daedalus.pq.iki.fi>
	<Pine.LNX.4.58.0804141144500.9886@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 11:49:55 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 13 Apr 2008, Pekka Paalanen wrote:
> > +
> > +[Unimplemented feature:]
> > +During tracing you can place comments (markers) into the trace by
> > +$ echo "X is up" > /debug/tracing/marker
> 
> I can implement a marker feature (logdev does this). I'll see if I can get
> something working this week.

Cool, I assumed this would require support for variable length entries.
Even if it would be very limited in length, like 16 bytes, it would be useful.

> > +[This feature is not implemented yet!]
> > +Check your kernel log. If there are messages about mmiotrace losing events,
> 
> This is something of higher priority to implement. I'll work on that
> first.

Great!

> > +this is due to buffer overrun, and the trace is incomplete. You should enlarge
> > +the buffers and try again. [How?]
> 
> I pretty much have the infrastructure in place to implement this. Now it's
> just time to do it ;-)


Thank you :-)

-- 
Pekka Paalanen
http://www.iki.fi/pq/
