Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbXGFUlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbXGFUlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbXGFUlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:41:06 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33296 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759373AbXGFUlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:41:05 -0400
Date: Fri, 6 Jul 2007 13:40:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] VMI: remove CONFIG_DEBUG_PAGE_TYPE and associated
	bitrotted code
Message-ID: <20070706204038.GU4306@sequoia.sous-sol.org>
References: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain> <468E890A.1070504@s5r6.in-berlin.de> <20070706201625.GT4306@sequoia.sous-sol.org> <468EA27C.9060401@vmware.com> <468EA5E0.4070501@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468EA5E0.4070501@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Zachary Amsden wrote:
> >I'd rather keep it, even with bitrot - it was non-trivial to get 
> >correct, and found many surprises in the code; most notably, it can 
> >detect
> >
> >1) PTE writes to pages not declared as page tables
> >2) Failure to allocate or de-allocate page tables using the 
> >paravirt-ops API
> >3) PTE writes using the wrong level operations
> >
> >These are most useful properties; in fact, I would like to extend the 
> >code for 64-bit paravirt-ops and 4-level paging, so rather not kill it 
> >until then.
> >
> >I never merged the whole bit upstream because it added a field to 
> >struct page. 
> 
> Hm, is that a big problem?  It would be OK for a debug config option, 
> wouldn't it?  Also, it doesn't seem particularly vmi-specific.  Could it 
> be made part of the pvops infrastructure?

I'm pretty sure lguest64 hit some of the problems Zach is trying to
catch, so should generalize well-enough.

thanks,
-chris
