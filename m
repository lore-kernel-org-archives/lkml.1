Return-Path: <linux-kernel-owner+w=401wt.eu-S1030866AbXCNTxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030866AbXCNTxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030872AbXCNTxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:53:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030866AbXCNTxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:53:32 -0400
Message-ID: <45F850BF.5030702@redhat.com>
Date: Wed, 14 Mar 2007 15:45:03 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org>
In-Reply-To: <45F84E39.7030507@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

>> How is time quantum getting stolen less important?  Time quantum
>> getting stolen results directly in more unnecessary context switches
>> since we might steal the entire timeslice before the process even ran.
> 
> It doesn't matter why you didn't get the time; 

Oh, but it does.

System administrators can use steal time the same way they
use iowait time: to spot bottlenecks on their systems.

If you have a lot of iowait time, you know you want either
faster IO or more memory.

If you have a lot of steal time, you know you need to spread
your virtual machines over more CPUs.

Steal time allows you to see the difference between a busy
system and an overloaded system.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
