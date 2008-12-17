Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758493AbYLQC2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbYLQC2t (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYLQC2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:28:39 -0500
Received: from fmailhost06.isp.att.net ([204.127.217.106]:37790 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYLQC2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:28:38 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2008 21:28:38 EST
X-Originating-IP: [70.153.126.210]
From: "Dan Terpstra" <terpstra@eecs.utk.edu>
To: "'Paul Mackerras'" <paulus@samba.org>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Robert Richter'" <robert.richter@amd.com>,
        <linux-kernel@vger.kernel.org>, "'Eric Dumazet'" <dada1@cosmosbay.com>,
        "'Stephane Eranian'" <eranian@googlemail.com>,
        "'Peter Anvin'" <hpa@zytor.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        <perfctr-devel@lists.sourceforge.net>,
        "'Arjan van de Ven'" <arjan@infradead.org>
References: <20081214212829.GA9435@elte.hu><18758.18810.350923.806445@cargo.ozlabs.ibm.com><1229437341.7025.11.camel@twins> <18760.13407.568536.198724@cargo.ozlabs.ibm.com>
Subject: RE: [Perfctr-devel] [patch] Performance Counters for Linux, v4
Date: Tue, 16 Dec 2008 21:23:32 -0500
Message-ID: <2295324823AE49DEA5B367C52CE5FBE4@terpstrat60p>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Aclf0xV8irZ7iey+Rqu9lY9APIp4ZAAGnXrA
In-Reply-To: <18760.13407.568536.198724@cargo.ozlabs.ibm.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Peter Zijlstra writes:
> 
> > On Mon, 2008-12-15 at 23:11 +1100, Paul Mackerras wrote:
> > > I think the core should put together a list of counters and counter
> > > groups that it would like to have on the PMU simultaneously and then
> > > make one call to the arch layer to ask if that is possible.  That
> > > could either return success or failure.  If it returns failure then
> > > the core needs to ask for something less, or something different.  I'm
> > > not sure how the core should choose what to ask for instead, though.
> >
> > I think the constraint set should be applied when we add to a group, if
> > when we add a counter to the group, the result isn't schedulable
> > anymore, we should fail the group addition - and thereby the counter
> > creation.
> >
> > This would leave us with groups that are always schedulable in an atomic
> > fashion.
> 
> I agree that if adding a counter to a group results in that group not
> being schedulable any more, we should fail the addition.
> 
That's what PAPI does.
In userspace.
Using libpfm.
Before counting anything.
On linux, AIX, Windows, Cray...
Talking to perfmon, perfctr, our own drivers, and maybe someday even the
linux performance counter subsystem.
- d

