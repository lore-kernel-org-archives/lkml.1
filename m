Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0AOOZR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727Ab0AOOZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:25:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:45607 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab0AOOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:25:15 -0500
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>,
        utrace-devel <utrace-devel@redhat.com>
In-Reply-To: <20100115142007.GA1628@linux.vnet.ibm.com>
References: <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
	 <1263467394.4244.291.camel@laptop>
	 <1263509380.4875.35.camel@localhost.localdomain>
	 <1263546632.4244.352.camel@laptop> <y0mvdf3en1y.fsf@fche.csb>
	 <1263548124.4244.358.camel@laptop> <20100115131037.GP4822@redhat.com>
	 <1263561930.4244.417.camel@laptop> <20100115133825.GQ4822@redhat.com>
	 <1263563276.4244.426.camel@laptop>
	 <20100115142007.GA1628@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 15:25:09 +0100
Message-ID: <1263565509.4244.432.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 19:50 +0530, Srikar Dronamraju wrote:

> > Srikar seemed to suggest it needed stop/resume.
> > 
> 
> If process traps, We dont need to stop/resume other threads.
> uprobes needs threads to quiesce when inserting/deleting the breakpoint.

Right, I don't think we need to at all. See the CoW thing from previous
emails.

