Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbXJLDRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbXJLDRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbXJLDRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:17:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:4663 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214AbXJLDRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,263,1188802800"; 
   d="scan'208";a="297117904"
Subject: Re: [PATCH 0/2 -mm] kexec based hibernation -v5
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <200710111217.58473.rjw@sisk.pl>
References: <1192068833.27482.13.camel@caritas-dev.intel.com>
	 <200710111217.58473.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Oct 2007 11:19:32 +0800
Message-Id: <1192159172.17539.26.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 12 Oct 2007 03:17:28.0867 (UTC) FILETIME=[6B7A9F30:01C80C7E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-11 at 12:17 +0200, Rafael J. Wysocki wrote:
> On Thursday, 11 October 2007 04:13, Huang, Ying wrote:
> > Kexec base hibernation has some potential advantages over uswsusp and
> > TuxOnIce (suspend2). Some most obvious advantages are:
> 
> Well, I have some doubts as far as the obviousness is concerned.

OK, I will remove the "obvious".

> > 1. The hibernation image size can exceed half of memory size easily.
> 
> This is also possible with TuxOnIce.

I will add detail description about this. It is possible with TuxOnIce,
and hard with u/swsusp.

> 
> > 2. The hibernation image can be written to and read from almost
> >    anywhere, such as USB disk, NFS.
> 
> This is possible with uswsusp, at least in theory, probably with TuxOnIce too.

I will remove this.

> > 3. It is possible to eliminate freezer from kexec based hibernation
> >    implementation.
> 
> This isn't true as long as we have not changed the handling of devices
> (which is in the works, but will take time).

I know it has not been implemented yet. I just say that it is possible
for khibernation and it is almost impossible for u/swsusp and TuxOnIce.

> > 4. Based on kexec/kdump implementation, the kernel code needed is
> >    less.
> 
> Well, maybe.
> 

Best Regards,
Huang Ying
