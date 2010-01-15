Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0AONK5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665Ab0AONK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:10:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab0AONKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:10:55 -0500
Date: Fri, 15 Jan 2010 08:10:37 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100115131037.GP4822@redhat.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com> <1263467394.4244.291.camel@laptop> <1263509380.4875.35.camel@localhost.localdomain> <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb> <1263548124.4244.358.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263548124.4244.358.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> > > Then we can ditch the whole utrace muck as I see no reason to want to
> > > use that, whereas the ubp (given a sane name) looks interesting.
> > 
> > Assuming you meant what you write, perhaps you misunderstand the
> > layering relationship of these pieces.  utrace underlies uprobes and
> > other process manipulation functionality, present and future.
> 
> Why, utrace doesn't at all look to bring a fundamental contribution to
> all that. If there's a proper kernel interface to install probes on
> userspace code (ubp seems to be mostly that) then I can use perf/ftrace
> to do the rest of the state management, no need to use utrace there.

> You can hardly force me to use utrace there, can you?

utrace is not a form of punishment inflicted upon the undeserving.  It
is a service layer that uprobes et alii are built upon.  You as a
potential uprobes client need not also talk directly to it, if you
wish to reimplement task-finder-like services some other way.

- FChE
