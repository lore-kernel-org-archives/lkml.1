Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbZFPQe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbZFPQe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbZFPQeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:34:15 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53037 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760180AbZFPQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:34:14 -0400
Date: Tue, 16 Jun 2009 22:03:52 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 2/4] cpu: sysfs interface for hotplugging bunch of
	CPUs.
Message-ID: <20090616163352.GA6005@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com> <20090616053849.30891.17453.stgit@sofia.in.ibm.com> <m3iqiwup0f.fsf@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3iqiwup0f.fsf@pobox.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 11:22:56AM -0500, Nathan Lynch wrote:
> Gautham R Shenoy <ego@in.ibm.com> writes:
> > echo 2,3 > /sys/devices/system/cpu/offline #Offlines CPUs 2 and 3
> > echo 4 > /sys/devices/sytem/cpu/offline    #Offlines CPU 4
> > echo 2-4 > /sys/devices/system/cpu/online  #Onlines CPU 2,3,4
> >
> > This patch changes the permissions of these sysfs files from 0444 to 0644.
> > It provides a dummy store function, which currently parses the input
> > provided by the user and copies them to another debug cpumask structure,
> > which can be accessed using the sysfs interfaces:
> > 	/sys/devices/system/cpu/debug_offline
> > and
> > 	/sys/devices/system/cpu/debug_online
> >
> > Thus on performing a
> > 	echo 2,3 > /sys/devices/system/cpu/offline
> > the operation
> > 	cat /sys/devices/system/cpu/debug_offline
> > should yield
> > 	2-3
> > as the result.
> 
> These debug_(on|off)line attributes aren't intended to be in the final
> result, are they?  They don't seem useful beyond the development phase
> of this feature...

No, they aren't intended to be in the final result.

-- 
Thanks and Regards
gautham
