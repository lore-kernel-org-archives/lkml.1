Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXLUI6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXLUI6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 03:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbXLUI6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 03:58:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:40540 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbXLUI6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 03:58:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,193,1196668800"; 
   d="scan'208";a="453009917"
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
From: "Huang, Ying" <ying.huang@intel.com>
To: nigel@nigel.suspend2.net
Cc: Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <476B7ACF.8020602@nigel.suspend2.net>
References: <1198222399.1965.15.camel@caritas-dev.intel.com>
	 <476B7ACF.8020602@nigel.suspend2.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Dec 2007 16:53:27 +0800
Message-Id: <1198227207.25346.11.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 21 Dec 2007 08:53:24.0836 (UTC) FILETIME=[F249EA40:01C843AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-21 at 19:35 +1100, Nigel Cunningham wrote:
> Hi.
> 
> Huang, Ying wrote:
> > This patchset provides an enhancement to kexec/kdump. It implements
> > the following features:
> > 
> > - Backup/restore memory used both by the original kernel and the
> >   kexeced kernel.
> 
> Why the kexeced kernel as well?

The memory range used by kexeced kernel is also the usable memory range
in original kernel. Maybe should be: backup/restore memory used by both
the original kernel and the kexeced kernel. My English is poor.

> [...]
> 
> > The features of this patchset can be used as follow:
> > 
> > - Kernel/system debug through making system snapshot. You can make
> >   system snapshot, jump back, do some thing and make another system
> >   snapshot.
> 
> Are you somehow recording all the filesystem changes after the first
> snapshot? If not, this is pointless (you'll end up with filesystem
> corruption).

This snapshot is not used for restore/resume. It is just used for
debugging. You can check the system state with these snapshots. So I
think it is useful even without recording filesystem changes.

> [...]
> 
> > - Cooperative multi-kernel/system. With kexec jump, you can switch
> >   between several kernels/systems quickly without boot process except
> >   the first time. This appears like swap a whole kernel/system out/in.
> 
> How is this useful to the end user?

I am not sure how useful is this. Maybe I can run a Redhat and a Debian
on my machine and switch between them.

Best Regards,
Huang Ying

