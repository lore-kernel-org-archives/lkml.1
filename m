Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbXFVR3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbXFVR3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXFVR2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:28:51 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46981 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbXFVR2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:28:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@elte.hu>,
       asit.k.mallick@intel.com
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
References: <m1tztt3yqy.fsf@ebiederm.dsl.xmission.com>
	<200706130016.09490.rjw@sisk.pl>
	<20070612222432.GC17143@linux-os.sc.intel.com>
	<200706130058.43227.rjw@sisk.pl>
Date: Fri, 22 Jun 2007 11:27:20 -0600
In-Reply-To: <200706130058.43227.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 13 Jun 2007 00:58:42 +0200")
Message-ID: <m18xabdhmv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
> OK, thanks.
>
> Eric, would you agree to follow this plan without making the entire CPU hotplug
> (on x86) depend on BROKEN?


Sorry for the delay, I missed this email.  If we can actually move irq
migration into process context on x86.  I would be happy to.

Currently I am dubious if this can be done reliably.  But I think
the benefits of doing irq migration outside of the irq handler
are sufficient to give another go at making it work.

However this isn't just Intel's ioapics we have to worry about,
but Intel's were the worst so that is a reasonable starting point.

Eric
