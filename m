Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbXJ2Tq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbXJ2Tq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbXJ2ToU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:44:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747AbXJ2ToS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:44:18 -0400
Date: Mon, 29 Oct 2007 15:43:11 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23 boot failures on x86-64.
Message-ID: <20071029194311.GE1650@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Martin Ebourne <fedora@ebourne.me.uk>,
	Zou Nan hai <nanhai.zou@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20071029175014.GH7793@redhat.com> <200710291918.43869.ak@suse.de> <20071029184747.GB1650@redhat.com> <200710292003.09317.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710292003.09317.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 08:03:09PM +0100, Andi Kleen wrote:

 > >  > It's probably the usual "nobody tests sparsemem at all" issue.
 > > 
 > > We've been using SPARSEMEM in Fedora for a *long* time.
 > > So long in fact, I forget why we moved away from DISCONTIGMEM, so there's
 > > a significant number of users using that configuration for some time.
 > 
 > Supposedly you wanted a slower kernel that needs more memory? 
 > 
 > Ok I wasn't aware of that. I tended to get sparsemem reports usually
 > at least 1-2 releases after the fact, so it looked like it was undertested.

Looking at cvs history, I can't figure out what the reasoning was,
but every Fedora (and RHEL5) kernel since 2006/07/05 has been that way.

Curious how no-one noticed either of the side-effects you mention.
 
 > >  > But if allocating bootmem >4G doesn't work on these systems
 > >  > most likely they have more problems anyways. It might be better
 > >  > to find out what goes wrong exactly.
 > > Any ideas on what to instrument ?
 > 
 > See what address the bootmem_alloc_high returns; check if it overlaps
 > with something etc.
 > 
 > Fill the memory on the system and see if it can access all of its memory.

Martin, as you have one of the affected systems, do you feel up to this?

	Dave

-- 
http://www.codemonkey.org.uk
