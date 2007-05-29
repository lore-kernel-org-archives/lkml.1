Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbXE2SK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbXE2SK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXE2SKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:10:19 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53154 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbXE2SKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:10:18 -0400
Subject: Re: Apparent Deadlock with nfsd/jfs on 2.6.21.1 under bonnie.
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Roger Heflin <rheflin@atipa.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <465C5FDF.4070401@atipa.com>
References: <4649BED9.6090207@atipa.com>
	 <pan.2007.05.15.22.03.07.359081@linux.vnet.ibm.com>
	 <464C68A0.2050003@atipa.com>
	 <1179413287.13965.24.camel@kleikamp.austin.ibm.com>
	 <465C5FDF.4070401@atipa.com>
Content-Type: text/plain
Date: Tue, 29 May 2007 13:10:15 -0500
Message-Id: <1180462215.10013.2.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 12:16 -0500, Roger Heflin wrote:

> Dave,
> 
> Apparently there appears to be another different similar lockup,
> The MTBF has risen from 1-2 hours without that patch to >100 hours,
> so I am fairly sure the patch did correct the original lockup, or
> at the very least make it a lot less likely.
> 
> I hit the machine across NFS for 5 days before it deadlocked, before
> the patch I could only get an hour or two (2-4 different tries).
> 
> Given that pdflush is "D" it does not appear to be an NFS issue.
> 
> Included is the sysrq-t.
> 
> This is with 2.6.21.1 + the JFSIO patch.

Is the system still in this state?  Can you cat /proc/fs/jfs/TxAnchor
(if CONFIG_JFS_DEBUG is defined) and /proc/fs/jfs/txstats (if
CONFIG_JFS_STATISTICS is defined)?

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

