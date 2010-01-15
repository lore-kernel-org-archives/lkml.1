Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab0AOOGv (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407Ab0AOOGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:06:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0AOOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:06:50 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
In-Reply-To: <20100115140042.GR4822@redhat.com>
References: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb>
	 <1263548124.4244.358.camel@laptop> <20100115131037.GP4822@redhat.com>
	 <1263561930.4244.417.camel@laptop> <20100115133825.GQ4822@redhat.com>
	 <1263563276.4244.426.camel@laptop>  <20100115140042.GR4822@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 15:06:43 +0100
Message-ID: <1263564403.4244.430.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 09:00 -0500, Frank Ch. Eigler wrote:

> Well, I'm not in a position to argue line by line about the necessity
> or the cost of utrace low level guts, but this may represent the most
> practical engineering balance between functionality / modularity /
> undesirably intrusive modifications. 

How intrusive and non-modular is installing a DIE_INT3 notifier?

