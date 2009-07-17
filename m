Return-Path: <linux-kernel-owner+w=401wt.eu-S964954AbZGQQsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954AbZGQQsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964939AbZGQQsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:48:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:45773 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934732AbZGQQsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:48:14 -0400
Subject: Re: [patch 2/2] sched: fix nr_uninterruptible accounting of frozen
 tasks really
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Nathan Lynch <ntl@pobox.com>,
       Nigel Cunningham <nigel@tuxonice.net>, stable@kernel.org,
       containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20090717152235.GA5878@count0.beaverton.ibm.com>
References: <20090717121545.489258927@linutronix.de>
	 <20090717122103.225652146@linutronix.de> <1247833910.15751.61.camel@twins>
	 <20090717152235.GA5878@count0.beaverton.ibm.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 18:47:34 +0200
Message-Id: <1247849254.6522.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 08:22 -0700, Matt Helsley wrote:

> The job scheduler in question does not use FROZEN as a transient state and
> does not use checkpoint/restart at all since c/r is still a work in progress.
> Even when used for power management it seems wrong to count frozen tasks
> towards the loadavg since they aren't using CPU time or waiting for IO.

You're abusing it for _WHAT_?



