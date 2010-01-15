Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0AOJ05 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188Ab0AOJ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:26:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab0AOJ0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:26:55 -0500
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	<20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	<1263467394.4244.291.camel@laptop>
	<1263509380.4875.35.camel@localhost.localdomain>
	<1263546632.4244.352.camel@laptop>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 15 Jan 2010 04:26:33 -0500
In-Reply-To: <1263546632.4244.352.camel@laptop> (Peter Zijlstra's message of "Fri, 15 Jan 2010 10:10:32 +0100")
Message-ID: <y0mvdf3en1y.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> [...]
> Right, so all that need be done is add the multiple probe stuff to UBP
> and its a sane interface to use on its own, at which point I'd be
> inclined to call that uprobes (UBP really is an crap name).

At one point ubp+uprobes were one piece.  They were separated on the
suspicion that lkml would like them that way.

> Then we can ditch the whole utrace muck as I see no reason to want to
> use that, whereas the ubp (given a sane name) looks interesting.

Assuming you meant what you write, perhaps you misunderstand the
layering relationship of these pieces.  utrace underlies uprobes and
other process manipulation functionality, present and future.

- FChE
