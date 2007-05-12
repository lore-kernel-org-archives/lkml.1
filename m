Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbXELJPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbXELJPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 05:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbXELJPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 05:15:08 -0400
Received: from www.osadl.org ([213.239.205.134]:60486 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754732AbXELJPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 05:15:05 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070512020056.a24cf472.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	 <20070511132846.5ebf4437.akpm@linux-foundation.org>
	 <200705112302.47726.rjw@sisk.pl> <200705112309.15996.rjw@sisk.pl>
	 <20070511235607.83ad0eb5.akpm@linux-foundation.org>
	 <1178959563.22481.126.camel@localhost.localdomain>
	 <20070512020056.a24cf472.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 12 May 2007 11:18:09 +0200
Message-Id: <1178961489.22481.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 02:00 -0700, Andrew Morton wrote:
>
> Still hangs in the same fashion, sorry.

I did not really expect that it fixes the problem. It just restored the
local APIC suspend/resume register fiddling which we had before the
resume logic patch.

> It's peculiar that the hang happens when acpi_evaluate_object() hits its
> return statement.  Any theories there?

Only stack or memory corruption come into mind, but I have no clue how
this is related to the resume logic changes.

	tglx


