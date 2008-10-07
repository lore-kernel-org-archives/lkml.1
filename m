Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYJGQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYJGQ4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYJGQ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:56:37 -0400
Received: from testure.choralone.org ([194.9.77.134]:41867 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbYJGQ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:56:36 -0400
Date: Tue, 7 Oct 2008 12:58:39 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, oleg@tv-sign.ru,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jean-Luc Coulon <jean.luc.coulon@gmail.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: [Bug #11264] Invalid op opcode in kernel/workqueue
Message-ID: <20081007165839.GA24117@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, oleg@tv-sign.ru,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Jean-Luc Coulon <jean.luc.coulon@gmail.com>,
	venkatesh.pallipadi@intel.com
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.oLB.b875IB@wind> <200810080223.03395.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810080223.03395.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 02:23:03AM +1100, Nick Piggin wrote:
 > On Sunday 05 October 2008 04:32, Rafael J. Wysocki wrote:
 > > This message has been generated automatically as a part of a report
 > > of recent regressions.
 > >
 > > The following bug entry is on the current list of known regressions
 > > from 2.6.26.  Please verify if it still should be listed and let me know
 > > (either way).
 > >
 > >
 > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
 > > Subject		: Invalid op opcode in kernel/workqueue
 > > Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
 > > Date		: 2008-08-07 04:18 (59 days old)
 > 
 > Any progress being made with this one? Dave, Oleg did some pretty
 > nice looking debugging work that indicates it might be a cpufreq
 > problem. Have you had a chance to look at the comments in the
 > bugzilla? Or have you been cc'ed on patches for this?

I'm not convinced that the original report wasn't hardware related.
We had taken a machine check exception already, which shows that something
isn't quite right.  MCEs happening under high load are usually a sign
of thermal/power problems of some sort.

Oleg's comments may still hold true, independant of the report.
I've added Venki to the Cc: as he's recently rewritten considerable
amounts of the ondemand governor (though the workqueue mechanics
are pretty much the same).

	Dave

-- 
http://www.codemonkey.org.uk
