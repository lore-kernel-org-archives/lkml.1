Return-Path: <linux-kernel-owner+w=401wt.eu-S1763787AbYASCit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763787AbYASCit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 21:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759846AbYASCik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 21:38:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44958 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759707AbYASCik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 21:38:40 -0500
Date: Sat, 19 Jan 2008 03:42:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080119024200.GA24674@one.firstfloor.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <200801180846.03161.jesse.barnes@intel.com> <20080118181202.GA19889@one.firstfloor.org> <200801181102.50629.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181102.50629.jesse.barnes@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think it should be enabled on AMD too though. If the reordering breaks
> > it then blacklisting won't help anyways.

Actually it is already enabled on AMD. You check for is_cpu(INTEL)
but that just checks the generic MTRR architecture and all AMD CPUs
since K7 use that one too.

That is ok imho.

Perhaps it would be good to fix the incorrect comment though.


> >
> > -Andi
> >
> > [1] but I checked the known errata and there was nothing related to MTRR.
> 
> Ah, ok, that explains your reticence earlier.  Thanks for testing again, I 
> guess the patch is good to go.

I see a failure here now on a (AMD) system where it trims a lot of memory, but
should probably not (or at least i haven't noticed any malfunction
before without it). Investigating. 

-Andi

