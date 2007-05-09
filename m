Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbXEIMVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbXEIMVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbXEIMVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:21:11 -0400
Received: from www.osadl.org ([213.239.205.134]:48940 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbXEIMVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:21:09 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200705091345.55207.rjw@sisk.pl>
References: <20070430102837.748238000@linutronix.de>
	 <20070509013119.dbea7233.akpm@linux-foundation.org>
	 <1178701183.3042.469.camel@localhost.localdomain>
	 <200705091345.55207.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 09 May 2007 14:24:02 +0200
Message-Id: <1178713442.3042.480.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 13:45 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 9 May 2007 10:59, Thomas Gleixner wrote:
> > On Wed, 2007-05-09 at 01:31 -0700, Andrew Morton wrote:
> > > > I suspect I just tested the wrong thing yesterday.  Let me recheck just
> > > > these patches against 2.6.21.
> > > 
> > > yup, same hang with just these three:
> > > 
> > > origin
> > > clocksource-fix-resume-logic
> > > clockevents-fix-resume-logic-updated-version
> > 
> > I have no idea, how this affects acpi_evaluate_object()
> 
> I think the problem is that the ACPI code ordering here is broken in a
> difficult to fix way.

Any explanation aside of witchcraft why this is affected by the clock
event resume changes ?

	tglx


