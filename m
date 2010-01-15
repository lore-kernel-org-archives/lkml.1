Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0AOJfh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036Ab0AOJfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:35:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:49168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0AOJff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:35:35 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
In-Reply-To: <y0mvdf3en1y.fsf@fche.csb>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop>  <y0mvdf3en1y.fsf@fche.csb>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 10:35:24 +0100
Message-ID: <1263548124.4244.358.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 04:26 -0500, Frank Ch. Eigler wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > [...]
> > Right, so all that need be done is add the multiple probe stuff to UBP
> > and its a sane interface to use on its own, at which point I'd be
> > inclined to call that uprobes (UBP really is an crap name).
> 
> At one point ubp+uprobes were one piece.  They were separated on the
> suspicion that lkml would like them that way.

Right, good thinking, that way we can use ubp without having to use
utrace ;-)

> > Then we can ditch the whole utrace muck as I see no reason to want to
> > use that, whereas the ubp (given a sane name) looks interesting.
> 
> Assuming you meant what you write, perhaps you misunderstand the
> layering relationship of these pieces.  utrace underlies uprobes and
> other process manipulation functionality, present and future.

Why, utrace doesn't at all look to bring a fundamental contribution to
all that. If there's a proper kernel interface to install probes on
userspace code (ubp seems to be mostly that) then I can use perf/ftrace
to do the rest of the state management, no need to use utrace there.

You can hardly force me to use utrace there, can you?

