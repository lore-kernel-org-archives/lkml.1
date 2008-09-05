Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYIEVEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYIEVEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYIEVDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:03:41 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:65038 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752477AbYIEVDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:03:39 -0400
Date: Fri, 5 Sep 2008 22:02:22 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch 1/2] x2apic: fix reserved APIC register accesses in
 print_local_APIC()
In-Reply-To: <20080905160414.GL10292@elte.hu>
Message-ID: <Pine.LNX.4.55.0809052151430.7062@cliff.in.clinika.pl>
References: <20080902234759.554038000@linux-os.sc.intel.com>
 <Pine.LNX.4.55.0809030625520.23174@cliff.in.clinika.pl>
 <20080903184552.GE14481@linux-os.sc.intel.com>
 <Pine.LNX.4.55.0809032145020.23174@cliff.in.clinika.pl> <20080905160414.GL10292@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008, Ingo Molnar wrote:

> hm, is the remote read debug output, now that it's not present in CPUs 
> made in the past 5 years or so, really that important?

 Maybe, maybe not, but if included it should be done correctly or
otherwise anotated why done differently.  Otherwise people may get
confused and propagate incorrect information as not everybody is inclined
to chase and cross-refer the relevant piece of documentation for each and
every bit of code fiddling with hardware.  In fact the requirement to do
so reduces trust in code it applies to and makes long-term maintenance a
nightmare.

 This observation applies universally of course.  I tend to look at code
without referring to documentation too as most often than not this is much
more effective time-wise.

  Maciej
