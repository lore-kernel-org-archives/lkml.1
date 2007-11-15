Return-Path: <linux-kernel-owner+w=401wt.eu-S1763603AbXKORp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763603AbXKORp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbXKORpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:45:21 -0500
Received: from bes.cs.utk.edu ([160.36.56.220]:34209 "EHLO bes.cs.utk.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569AbXKORpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:45:19 -0500
X-Greylist: delayed 2579 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 12:45:19 EST
From: "Dan Terpstra" <terpstra@eecs.utk.edu>
To: "'dean gaudet'" <dean@arctic.org>, "'Andi Kleen'" <andi@firstfloor.org>
Cc: "'papi list'" <ptools-perfapi@cs.utk.edu>,
       "'OSPAT devel'" <ospat-devel@cs.utk.edu>, "'Greg KH'" <gregkh@suse.de>,
       "'Perfmon'" <perfmon@napali.hpl.hp.com>, <linux-kernel@vger.kernel.org>,
       "'Christoph Hellwig'" <hch@infradead.org>,
       "'Paul Mackerras'" <paulus@samba.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <perfmon2-devel@lists.sourceforge.net>,
       "'Philip Mucci'" <mucci@cs.utk.edu>
References: <p73abpl2654.fsf@bingen.suse.de><20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com><20071113175545.GD4319@frankl.hpl.hp.com><53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu><20071113185924.GA22748@suse.de><20071113120728.4342e7d7.akpm@linux-foundation.org><18234.41652.199520.31261@cargo.ozlabs.ibm.com><20071114103805.GA16652@infradead.org><18234.53558.883970.87414@cargo.ozlabs.ibm.com><20071114110009.GA17833@infradead.org><p734pfp6lyp.fsf@bingen.suse.de> <alpine.DEB.0.9999.0711142006020.7260@twinlark.arctic.org>
Subject: RE: [perfmon2] [perfmon] Re:  perfmon2 merge news
Date: Thu, 15 Nov 2007 12:01:41 -0500
Message-ID: <004301c827a9$3eedb060$1ce2dd8c@terpstrat60p>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <alpine.DEB.0.9999.0711142006020.7260@twinlark.arctic.org>
Thread-Index: AcgnUdF1cEPv921mRcyNAW5742bNmAAVrUxQ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've provided multiplexing in PAPI at the user level for years. That forced
it to the user level, which wasn't pretty. Or very statistically accurate.
We've been eagerly anticipating the improvements provided by in-kernel
multiplexing in perfmon2. We and our user base don't consider this a "far
away non-essential feature", but a deficiency that's needed addressing for a
long time.
- d

> -----Original Message-----
> From: perfmon2-devel-bounces@lists.sourceforge.net [mailto:perfmon2-devel-
> bounces@lists.sourceforge.net] On Behalf Of dean gaudet
> Sent: Wednesday, November 14, 2007 11:20 PM
> To: Andi Kleen
> Cc: papi list; OSPAT devel; Greg KH; Perfmon; linux-
> kernel@vger.kernel.org; Christoph Hellwig; Paul Mackerras; Andrew Morton;
> perfmon2-devel@lists.sourceforge.net; Philip Mucci
> Subject: Re: [perfmon2] [perfmon] Re: perfmon2 merge news
> 
> On Wed, 14 Nov 2007, Andi Kleen wrote:
> 
> > Later a syscall might be needed with event multiplexing, but that seems
> > more like a far away non essential feature.
> 
> actually multiplexing is the main feature i am in need of. there are an
> insufficient number of counters (even on k8 with 4 counters) to do
> complete stall accounting or to get a general overview of L1d/L1i/L2 cache
> hit rates, average miss latency, time spent in various stalls, and the
> memory system utilization (or HT bus utilization).  this runs out to
> something like 30 events which are interesting... and re-running a
> benchmark over and over just to get around the lack of multiplexing is a
> royal pain in the ass.
> 
> it's not a "far away non-essential feature" to me.  it's something i would
> use daily if i had all the pieces together now (and i'm constrained
> because i cannot add an out-of-tree patch which adds unofficial syscalls
> to the kernel i use).
> 
> -dean
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> perfmon2-devel mailing list
> perfmon2-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/perfmon2-devel

