Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbXE2Sab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbXE2Sab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXE2SaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:30:21 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59887 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbXE2SaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:30:19 -0400
Subject: Re: Apparent Deadlock with nfsd/jfs on 2.6.21.1 under bonnie.
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Roger Heflin <rheflin@atipa.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <465C6D78.9030009@atipa.com>
References: <4649BED9.6090207@atipa.com>
	 <pan.2007.05.15.22.03.07.359081@linux.vnet.ibm.com>
	 <464C68A0.2050003@atipa.com>
	 <1179413287.13965.24.camel@kleikamp.austin.ibm.com>
	 <465C5FDF.4070401@atipa.com>
	 <1180462215.10013.2.camel@kleikamp.austin.ibm.com>
	 <465C6D78.9030009@atipa.com>
Content-Type: text/plain
Date: Tue, 29 May 2007 13:30:18 -0500
Message-Id: <1180463418.10013.5.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 13:14 -0500, Roger Heflin wrote:
> Dave Kleikamp wrote:
> > On Tue, 2007-05-29 at 12:16 -0500, Roger Heflin wrote:
> > 
> >> Dave,
> >>
> >> Apparently there appears to be another different similar lockup,
> >> The MTBF has risen from 1-2 hours without that patch to >100 hours,
> >> so I am fairly sure the patch did correct the original lockup, or
> >> at the very least make it a lot less likely.
> >>
> >> I hit the machine across NFS for 5 days before it deadlocked, before
> >> the patch I could only get an hour or two (2-4 different tries).
> >>
> >> Given that pdflush is "D" it does not appear to be an NFS issue.
> >>
> >> Included is the sysrq-t.
> >>
> >> This is with 2.6.21.1 + the JFSIO patch.
> > 
> > Is the system still in this state?  Can you cat /proc/fs/jfs/TxAnchor
> > (if CONFIG_JFS_DEBUG is defined) and /proc/fs/jfs/txstats (if
> > CONFIG_JFS_STATISTICS is defined)?
> > 
> > Thanks,
> > Shaggy
> 
> Yes, the machine is still in that state.
> 
> Apparently I don't have either of those configured.
> 
> Anything else that we can collect before I rebuild the kernel with
> those options setup?

No.  I think I may have found something to explain the hang.  I need to
look a bit closer.  Go ahead and rebuild the kernel with those options
in case I'm mistaken.

Thanks,
Shaggy

> 
>                               Roger
> 
-- 
David Kleikamp
IBM Linux Technology Center

