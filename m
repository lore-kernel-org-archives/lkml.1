Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbXJ3Rzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbXJ3Rzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXJ3Rzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:55:46 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:29164 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752489AbXJ3Rzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:55:45 -0400
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
In-Reply-To: <20071030172442.GA4477@Krystal>
References: <20071029215138.GA4233@Krystal>
	 <20071029154741.cb093f55.rdunlap@xenotime.net>
	 <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal>
	 <472667F3.3000505@garzik.org>  <20071030172442.GA4477@Krystal>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 18:49:54 +0100
Message-Id: <1193766594.9068.48.camel@taijtu>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 13:24 -0400, Mathieu Desnoyers wrote:
> * Jeff Garzik (jeff@garzik.org) wrote:
> ...
> > Pick a shorter word like probes or profile or what... or better yet... 
> > just leave most things in their current directories.
> ...
> 
> 
> How about something along the
> 
> kinst or ki
> 
> lines ?
> 
> (for "kernel instrumentation")

I think I'm with jgarzik on this, lets not do this until its clear where
the generalized instrumentation goes to.

That is, i386/x86_64 -> x86 was part of a full integration plan, one
that was immediately followed up by a series of integration patches.

With this, I see no such plan. Please draft this generic instrumentation
you talk about, if after that we all like it, we can go moving files
together with the immediate purpose of integrating them.



