Return-Path: <linux-kernel-owner+w=401wt.eu-S1764687AbXFAUbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764687AbXFAUbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763670AbXFAUbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:31:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35202 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763437AbXFAUba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:31:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
References: <fa.tUMR7tAB+jMgtfyl/LJ7U9QMgBs@ifi.uio.no>
	<200705312212.34053.rjw@sisk.pl>
	<m1d50fzcaa.fsf@ebiederm.dsl.xmission.com>
	<200706012206.15794.rjw@sisk.pl>
Date: Fri, 01 Jun 2007 14:29:43 -0600
In-Reply-To: <200706012206.15794.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 1 Jun 2007 22:06:14 +0200")
Message-ID: <m14plrzadk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Very well, but could you _please_ give us some time to do this?
>
> We know of the problem now and will work to fix it, but it's not _that_ easy.
>
> In fact, we also rely on the CPU hotplug's code that takes tasks away from the
> offlined CPUs (and does the opposite with respect to the onlined CPUs), so
> we just can't get rid of the CPU hotplug _right_ _now_.

Sure.  My primary point was to document this, and get things moving if
possible to fix it.  This patch is 2.6.23 at the earliest, so there is
some time to work on it even on the most optimistic merge schedule.

I just don't want to be complacent and let this problem sit undetected
in back corner any more.

Eric
