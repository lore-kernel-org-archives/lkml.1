Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXKOEsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXKOEsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbXKOEsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:48:01 -0500
Received: from ozlabs.org ([203.10.76.45]:43312 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbXKOEsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:48:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18235.53083.327055.165958@cargo.ozlabs.ibm.com>
Date: Thu, 15 Nov 2007 15:47:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: dean gaudet <dean@arctic.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, eranian@hpl.hp.com,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <alpine.DEB.0.9999.0711142006020.7260@twinlark.arctic.org>
References: <p73abpl2654.fsf@bingen.suse.de>
	<20071113151718.GA3804@erda.amd.com>
	<4739C42F.8030208@redhat.com>
	<20071113175545.GD4319@frankl.hpl.hp.com>
	<53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
	<20071113185924.GA22748@suse.de>
	<20071113120728.4342e7d7.akpm@linux-foundation.org>
	<18234.41652.199520.31261@cargo.ozlabs.ibm.com>
	<20071114103805.GA16652@infradead.org>
	<18234.53558.883970.87414@cargo.ozlabs.ibm.com>
	<20071114110009.GA17833@infradead.org>
	<p734pfp6lyp.fsf@bingen.suse.de>
	<alpine.DEB.0.9999.0711142006020.7260@twinlark.arctic.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet writes:

> actually multiplexing is the main feature i am in need of. there are an 
> insufficient number of counters (even on k8 with 4 counters) to do 
> complete stall accounting or to get a general overview of L1d/L1i/L2 cache 
> hit rates, average miss latency, time spent in various stalls, and the 
> memory system utilization (or HT bus utilization).  this runs out to 
> something like 30 events which are interesting... and re-running a 
> benchmark over and over just to get around the lack of multiplexing is a 
> royal pain in the ass.

So by "multiplexing" do you mean the ability to have multiple event
sets associated with a context and have the kernel switch between them
automatically?

Paul.
