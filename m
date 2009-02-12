Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZBLGG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZBLGG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZBLGGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:06:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:46397 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbZBLGGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:06:17 -0500
Subject: Re: Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, Paul Collins <paul@burly.ondioline.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0902091302310.415@localhost.localdomain>
References: <87prihcepl.fsf@burly.wgtn.ondioline.org>
	 <87k58nda87.fsf@burly.wgtn.ondioline.org>
	 <874oz5pmvd.fsf@burly.wgtn.ondioline.org> <200902081439.31548.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902091302310.415@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 17:05:24 +1100
Message-Id: <1234418724.29851.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The commit fixed the problem with sched_clock, but it does not fix
> problems where other parts of the kernel call timekeeping functions
> _AFTER_ timekeeping has been suspended.

Maybe we should use the PMU sysdev which is used for suspending
backlight stuff etc... to also suspend emitting of the input events.

Cheers,
Ben.


