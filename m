Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0AOJK6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379Ab0AOJK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:10:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0AOJKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:10:54 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263509380.4875.35.camel@localhost.localdomain>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 10:10:32 +0100
Message-ID: <1263546632.4244.352.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 14:49 -0800, Jim Keniston wrote:
> On Thu, 2010-01-14 at 12:09 +0100, Peter Zijlstra wrote:
> > On Mon, 2010-01-11 at 17:55 +0530, Srikar Dronamraju wrote:
> > > 
> > > Uprobes Infrastructure enables user to dynamically establish
> > > probepoints in user applications and collect information by executing
> > > a handler functions when the probepoints are hit.
> > > Please refer Documentation/uprobes.txt for more details.
> > > 
> > > This patch provides the core implementation of uprobes.
> > > This patch builds on utrace infrastructure.
> > > 
> > > You need to follow this up with the uprobes patch for your
> > > architecture. 
> > 
> > So all this is basically some glue between what you call ubp (the real
> > userspace breakpoint stuff) and utrace? Or does it do more?
> > 
> 
> My reply in
> http://lkml.indiana.edu/hypermail/linux/kernel/1001.1/02483.html
> addresses this.

Right, so all that need be done is add the multiple probe stuff to UBP
and its a sane interface to use on its own, at which point I'd be
inclined to call that uprobes (UBP really is an crap name).

Then we can ditch the whole utrace muck as I see no reason to want to
use that, whereas the ubp (given a sane name) looks interesting.

