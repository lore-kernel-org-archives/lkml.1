Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbZG0GSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbZG0GSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 02:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZG0GSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 02:18:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZG0GSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 02:18:49 -0400
Subject: Re: [Bug #13750] Load average flatlines after returning from
 hibernate
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Duncan <1i5t5.duncan@cox.net>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <3zAHs5O6maO.A.DfD.oHObKB@chimera>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.DfD.oHObKB@chimera>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 08:21:06 +0200
Message-Id: <1248675666.6987.1415.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13750
> Subject		: Load average flatlines after returning from hibernate
> Submitter	: Duncan <1i5t5.duncan@cox.net>
> Date		: 2009-07-09 15:14 (18 days old)
> 
> 

commit 6301cb95c119ebf324bb96ee226fa9ddffad80a7
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Jul 17 14:15:47 2009 +0200

    sched: fix nr_uninterruptible accounting of frozen tasks really


commit a468d389349a7560249b355cdb6d2097ea1616c9
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Jul 17 14:15:46 2009 +0200

    sched: fix load average accounting vs. cpu hotplug


