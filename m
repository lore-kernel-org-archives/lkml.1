Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXKOEUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXKOEUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbXKOEUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:20:24 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:51055 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbXKOEUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:20:23 -0500
Date: Wed, 14 Nov 2007 20:20:22 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Christoph Hellwig <hch@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, eranian@hpl.hp.com,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <p734pfp6lyp.fsf@bingen.suse.de>
Message-ID: <alpine.DEB.0.9999.0711142006020.7260@twinlark.arctic.org>
References: <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de>
 <20071113120728.4342e7d7.akpm@linux-foundation.org> <18234.41652.199520.31261@cargo.ozlabs.ibm.com> <20071114103805.GA16652@infradead.org> <18234.53558.883970.87414@cargo.ozlabs.ibm.com> <20071114110009.GA17833@infradead.org>
 <p734pfp6lyp.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Andi Kleen wrote:

> Later a syscall might be needed with event multiplexing, but that seems
> more like a far away non essential feature.

actually multiplexing is the main feature i am in need of. there are an 
insufficient number of counters (even on k8 with 4 counters) to do 
complete stall accounting or to get a general overview of L1d/L1i/L2 cache 
hit rates, average miss latency, time spent in various stalls, and the 
memory system utilization (or HT bus utilization).  this runs out to 
something like 30 events which are interesting... and re-running a 
benchmark over and over just to get around the lack of multiplexing is a 
royal pain in the ass.

it's not a "far away non-essential feature" to me.  it's something i would 
use daily if i had all the pieces together now (and i'm constrained 
because i cannot add an out-of-tree patch which adds unofficial syscalls 
to the kernel i use).

-dean
