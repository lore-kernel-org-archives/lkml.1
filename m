Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbYFAORE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbYFAORE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYFAOQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:16:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4363 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751333AbYFAOQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:16:50 -0400
Date: Sat, 31 May 2008 23:13:06 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080531211306.GM5405@ucw.cz>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526085000.33787eac@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > entitlement for the process as per the current CPU frequency.  This
> > technique is used in powerpc architecture with the help of hardware
> > registers that accurately capture the entitlement.
> > 
> 
> there are some issues with this unfortunately, and these make it
> a very complex thing to do. 
> Just to mention a few:
> 1) What if the BIOS no longer allows us to go to the max frequency for
> a period (for example as a result of overheating); with the approach
> above, the admin would THINK he can go faster, but he cannot in reality,
> so there's misleading information (the system looks half busy, while in

Plus time one-second-computation-job returning anything else is just
wrong. Even when it only happens when overheated... or only on battery
power.

If you want scaled utime, you need new interface.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
