Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXCOTSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXCOTSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXCOTSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:18:47 -0400
Received: from gw.goop.org ([64.81.55.164]:45266 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911AbXCOTSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:18:46 -0400
Message-ID: <45F99C10.1070500@goop.org>
Date: Thu, 15 Mar 2007 12:18:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com, Rik van Riel <riel@redhat.com>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org> <45F85A62.8050001@vmware.com> <45F85BBB.70707@goop.org> <45F85F43.9030803@vmware.com> <45F866AF.9060609@goop.org> <45F999D4.6080602@vmware.com>
In-Reply-To: <45F999D4.6080602@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> So, yes, it is per-vcpu.  But, the sched_clock() samples are rebased
> when processes are migrated between runqueues; search sched.c for
> most_recent_timestamp.  It's not perfect since most_recent_timestamp
> between cpu0 and cpu1 do not correspond to the exact same instant, but
> does prevent negative sleep time and is fairly close.

Yes, I noticed that when I looked more carefully, but I wasn't sure
whether it would be sufficient to make it all work out.

    J
