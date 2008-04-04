Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYDDILH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYDDILH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYDDIKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:10:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33896 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbYDDIKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:10:52 -0400
Date: Fri, 4 Apr 2008 10:10:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00 of 24] More Xen updates
Message-ID: <20080404081034.GB30799@elte.hu>
References: <patchbomb.1207158829@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1207158829@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> More patches.  There are three groups:
> 
> - some code movements to make common code available to other
>   architectures (namely, ia64)
> - Xen device driver updates, including a new xen paravirt framebuffer driver,
> - The Xen balloon driver (shrink only, so no dependency on memory hotplug yet)
> - some "using smp_processor_id while preemptable" warning fixes,
>   mostly as a result of the core kernel's tendency to do tlb flushes
>   and update init_mm while preemptable,
> - other little Xen cleanups

thanks, applied for testing. The .25 Xen items we've got queued up are:

 Subject: xen: refactor xen_{alloc,release}_{pte,pmd}()
 Subject: xen: do not pin/unpin PMD pages
 Subject: xen: clear PG_pinned in release_{pte,pmd}()

anything missing?

	Ingo
