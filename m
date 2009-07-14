Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZGNSYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZGNSYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZGNSYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:24:38 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:59136 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbZGNSYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:24:37 -0400
Message-ID: <4A5CCD5A.80108@nortel.com>
Date: Tue, 14 Jul 2009 12:24:26 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us>	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>	 <4A5C9ABA.9070909@nortel.com> <1247590112.9086.936.camel@Palantir>
In-Reply-To: <1247590112.9086.936.camel@Palantir>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 18:24:28.0983 (UTC) FILETIME=[532F1470:01CA04B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raistlin wrote:

> Remember that all my points are concerned with budgets, i.e., a scenario
> where you have some mean to limit the capability of a task to ask for
> CPU time over some kind of period.
> And here it is where the problem comes since running C instead of having
> A busy waiting means:
> - that A is actually blocked, as said before;

Why does it make any difference that A is blocked rather than busy
waiting?  In either case A cannot make forward progress.

> - that A's budget is not diminished.

If we're running B with A's priority, presumably it will get some amount
of cpu time above and beyond what it would normally have gotten during a
particular scheduling interval.  Perhaps it would make sense to charge B
what it would normally have gotten, and charge the excess amount to A?

Chris
