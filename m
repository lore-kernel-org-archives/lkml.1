Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbXIUIpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbXIUIpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbXIUIp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:45:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:52827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXIUIpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:45:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,282,1186383600"; 
   d="scan'208";a="299954106"
Subject: Re: [linux-pm] [RFC][PATCH 0/2 -mm] kexec based hibernation -v3
From: "Huang, Ying" <ying.huang@intel.com>
To: Stefan Rompf <stefan@loplof.de>
Cc: linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200709211043.38266.stefan@loplof.de>
References: <1190266440.21818.16.camel@caritas-dev.intel.com>
	 <200709211043.38266.stefan@loplof.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Sep 2007 16:47:11 +0800
Message-Id: <1190364431.21818.186.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 21 Sep 2007 08:45:21.0194 (UTC) FILETIME=[BE6CC0A0:01C7FC2B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 10:43 +0200, Stefan Rompf wrote:
> Am Donnerstag, 20. September 2007 07:34 schrieb Huang, Ying:
> 
> > The hibernation procedure with the patch set is as follow:
> >
> > 1. Boot a kernel A
> >
> > 2. Work under kernel A
> >
> > 3. Kexec another kernel B (crash dump enabled) in kernel A.
> 
> From a short glance over current Linus' arch/i386/kernel/machine_kexec.c, 
> memory for the crash dump kernel B still needs to be reserved statically when 
> booting A.
> 
> This is one of the biggest issues with kexec based hibernation. For the 
> typical notebook user, it is totally unacceptable to reserve 16 megabytes of 
> memory just to be able to suspend to disk. And given the fact that current 
> distribution kernels are quite modular and require early module loading, even 
> more memory might be needed.
> 
> IMHO, a plan how to fix this must exist or the concept of kexec based 
> hibernation is a waste of time.

This issue has been resolved. The implementation method details in
another mail with title as follow:

[RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump

Best Regards,
Huang Ying
