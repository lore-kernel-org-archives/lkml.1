Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0AOOWk (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008Ab0AOOWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:22:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698Ab0AOOWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:22:39 -0500
Date: Fri, 15 Jan 2010 09:22:13 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100115142213.GS4822@redhat.com>
References: <1263509380.4875.35.camel@localhost.localdomain> <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb> <1263548124.4244.358.camel@laptop> <20100115131037.GP4822@redhat.com> <1263561930.4244.417.camel@laptop> <20100115133825.GQ4822@redhat.com> <1263563276.4244.426.camel@laptop> <20100115140042.GR4822@redhat.com> <1263564403.4244.430.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263564403.4244.430.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> > Well, I'm not in a position to argue line by line about the necessity
> > or the cost of utrace low level guts, but this may represent the most
> > practical engineering balance between functionality / modularity /
> > undesirably intrusive modifications. 
> 
> How intrusive and non-modular is installing a DIE_INT3 notifier?

I'm not sure about all the reasons pro/con, but it looks like
installing such a systemwide hook would force every userspace
breakpoint or kprobe event machine wide to pass through the
hypothetical uprobes layer, whether or not applicable to a current
task.

- FChE
