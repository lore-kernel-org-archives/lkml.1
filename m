Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZKPXJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZKPXJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZKPXJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:09:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZKPXJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:09:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
Date: Tue, 17 Nov 2009 00:08:23 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.KbH.ZTdALB@chimera> <alpine.LSU.2.00.0911162354140.15039@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0911162354140.15039@wotan.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911170008.23972.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 November 2009, Jiri Kosina wrote:
> On Mon, 16 Nov 2009, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14467
> > Subject		: Linker errors on ia64 with NR_CPUS=4096
> > Submitter	: Jeff Mahoney <jeffm@suse.com>
> > Date		: 2009-10-18 22:28 (30 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=34d76c41554a05425613d16efebb3069c4c545f0
> > References	: http://marc.info/?l=linux-kernel&m=125590493116720&w=4
> 
> Fixed by the following two commits
> 
> 
> commit 4a6cc4bd32e580722882115d4c8b964d732c11e4
> Author: Jiri Kosina <jkosina@suse.cz>
> Date:   Thu Oct 29 00:26:00 2009 +0900
> 
>     sched: move rq_weight data array out of .percpu
> 
> commit 403a91b1659cb149dbddc5885f892734ae4542d8
> Author: Jiri Kosina <jkosina@suse.cz>
> Date:   Thu Oct 29 00:25:59 2009 +0900
> 
>     percpu: allow pcpu_alloc() to be called with IRQs off

Thanks, closed.

Rafael
