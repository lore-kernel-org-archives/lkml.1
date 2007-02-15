Return-Path: <linux-kernel-owner+w=401wt.eu-S1161557AbXBOWak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161557AbXBOWak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161558AbXBOWak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:30:40 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:58309 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161557AbXBOWaj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:30:39 -0500
Date: Thu, 15 Feb 2007 17:30:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: Re: [PATCH 00/05] Linux Kernel Markers - kernel 2.6.20
Message-ID: <20070215223037.GA6297@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231201.20918c6b.akpm@linux-foundation.org> <y0mvei330ee.fsf@ton.toronto.redhat.com> <20070215141841.6eed5fbb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070215141841.6eed5fbb.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 17:22:09 up 13 days, 12:30,  7 users,  load average: 1.02, 1.08, 1.15
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On 15 Feb 2007 10:28:57 -0500
> fche@redhat.com (Frank Ch. Eigler) wrote:
> 
> > 
> > akpm wrote:
> > 
> > > [...]  And what can I do with these markers?  And once I've done it,
> > > are there any userspace applications I can use to get the data out
> > > in human-usable form?  [...]
> > 
> > The LTTng user-space programs use it today.  Systemtap used to support
> > the earlier marker prototype and will be rapidly ported over to this
> > new API upon acceptance.
> > 
> 
> That's good.
> 
> It would be beneficial if some people from those projects could spare the
> cycles to carefully review and runtime test this code.
> 
LTTng is using the marker infrastructure since last november. Me and my
users have been very happy with it.

> Also, I'm not 100% clear on where we ended up with the huge
> static-vs-dynamic flamewar.  Did everyone end up happy?  Is this patchset a
> reasonable compromise?  Or do we need a rematch?

I think the final agreement was the need for some kind of code marking
system, which I tried to implement as best as I could. It gives very
good performances while tracing (advantage of static tracing), has a
very very minimal performance and binary size impact when disabled
(advantage of dynamic tracing) and it can be activated dynamically
(advantage of dynamic tracing).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
