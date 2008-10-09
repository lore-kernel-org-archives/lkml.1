Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYJIMxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYJIMxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbYJIMxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:53:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40815 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758084AbYJIMxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:53:23 -0400
Date: Thu, 9 Oct 2008 14:53:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted Execution Technology
	support for Linux - Overview
Message-ID: <20081009125311.GD1623@ucw.cz>
References: <D936D925018D154694D8A362EEB0892005AC105B@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D936D925018D154694D8A362EEB0892005AC105B@orsmsx416.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Value Proposition for Linux or "Why should you care?"
> =====================================================
> 
> While there are many products and technologies that attempt to measure
> or
> protect the integrity of a running kernel, they all assume the kernel is
> "good" to begin with.  The Integrity Measurement Architecture (IMA) and
> Linux
> Integrity Module interface are examples of such solutions.
> 
> To get trust in the initial kernel without using Intel TXT, a static
> root of
> trust must be used.  This bases trust in BIOS starting at system reset
> and
> requires measurement of all code executed between system reset through
> the
> completion of the kernel boot as well as data objects used by that code.
> In
> the case of a Linux kernel, this means all of BIOS, any option ROMs, the
> bootloader and the boot config.  In practice, this is a lot of
> code/data, much
> of which is subject to change from boot to boot (e.g. changing NICs may
> change
> option ROMs).  Without reference hashes, these measurement changes are
> difficult to assess or confirm as benign.  This process also does not
> provide DMA protection, memory configuration/alias checks and locks,
> crash
> protection, or policy support.

Ok, I don't get it, why would I want to measure my kernel?

I see why Disney would want to do that, but I don't see why we would
want to help them.

Plus, the fact that trusted mode is pretty much incompatible with
s3/s4 makes it useless, right?

So what is this good for?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
