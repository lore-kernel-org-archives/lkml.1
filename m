Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYKDQlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYKDQlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYKDQk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:40:59 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37576 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYKDQk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:40:58 -0500
Date: Tue, 4 Nov 2008 08:40:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bug #11876] RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081104164052.GA8499@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera> <4xS1r6m15_B.A.dU.7ueDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4xS1r6m15_B.A.dU.7ueDJB@chimera>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 05:49:38PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11876
> Subject		: RCU hang on cpu re-hotplug with 2.6.27rc8
> Submitter	: Andi Kleen <andi@firstfloor.org>
> Date		: 2008-10-06 23:28 (28 days old)
> References	: http://marc.info/?l=linux-kernel&m=122333610602399&w=2
> Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Hallo, Andi,

Last I heard, the act of enabling CONFIG_RCU_CPU_STALL_DETECTOR
reduced the problem from a hang to a 3-second grace period.  How
are things going with this now?

						Thanx, Paul
