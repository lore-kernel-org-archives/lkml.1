Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbXKPRvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbXKPRvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXKPRvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:51:10 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:38481 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbXKPRvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:51:09 -0500
Date: Fri, 16 Nov 2007 09:51:08 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Philip Mucci <mucci@cs.utk.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Stephane Eranian <eranian@hpl.hp.com>,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: perfmon2 merge news
In-Reply-To: <p737ikicjbn.fsf@bingen.suse.de>
Message-ID: <alpine.DEB.0.9999.0711160943470.15441@twinlark.arctic.org>
References: <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de>
 <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu> <20071114015210.GA20365@one.firstfloor.org> <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu>
 <p737ikicjbn.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Andi Kleen wrote:

> I didn't see a clear list. 

- cross platform extensible API for configuring perf counters
- support for multiplexed counters
- support for virtualized 64-bit counters
- support for PC and call graph sampling at specific intervals
- support for reading counters not necessarily with sampling
- taskswitch support for counters
- API available from userland
- ability to self-monitor: need select/poll/etc interface
- support for PEBS, IBS and whatever other new perf monitoring 
  infrastructure the vendors through at us in the future
- low overhead:  must minimize the "probe effect" of monitoring
- low noise in measurements:  cannot achieve this in userland

permon2 has all of this and more i've probably neglected...

-dean
