Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZERPN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZERPN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZERPNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:13:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34111 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZERPNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:13:10 -0400
Date: Mon, 18 May 2009 16:57:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jonathan Corbet <corbet@lwn.net>,
       Martin Bammer <mrb74@gmx.at>, Jeff Garzik <jgarzik@pobox.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Message-ID: <20090518145725.GB18607@redhat.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <20090517073327.GC1583@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090517073327.GC1583@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17, Ingo Molnar wrote:
>
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
> > Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
> > Submitter	: Kumar Gala <galak@kernel.crashing.org>
> > Date		: 2009-04-09 15:43 (38 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
> > References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
> > 		  http://lkml.org/lkml/2009/4/10/193
> > Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>
> Oleg says in that thread that it's as-designed, and followup
> questions were not replied to (yet).

Yes, I think this is false alarm. Perhaps I missed something, and
I am waiting for more info from Kumar, but it looks like ltp was
already changed to skip the "{ PTRACE_ATTACH, 1, EPERM }" test
on kernels after 2.6.25

Oleg.

