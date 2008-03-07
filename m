Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbYCGSjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbYCGSjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbYCGSiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:38:54 -0500
Received: from mail.tmr.com ([64.65.253.246]:59666 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417AbYCGSix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:38:53 -0500
Message-ID: <47D18CE1.7050206@tmr.com>
Date: Fri, 07 Mar 2008 13:43:45 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Justin Banks <justinb@bakbone.com>
CC: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: FW: Linux question
References: <DEE40752C8AF224BB890E455C7B8E0FE042B84B112@G6W0268.americas.hpqcorp.net> <20080306203841.GA4282@bleen.domain.actdsltmp>
In-Reply-To: <20080306203841.GA4282@bleen.domain.actdsltmp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Banks wrote:
> Miller, Mike (OS Dev) wrote
>> Is there a way in to limit the kernel to seeing only the cores on a
>> single processor and ignore all other processor cores (eg. leave
>> them in HALT)?
> 
> Can't you just echo 0 into /sys/devices/system/cpu/cpuN/online where the
> /sys/devices/system/cpu/cpuN/topology/physical_package_id isn't the one
> you want to keep online?
> 
Here's an interesting question, why isn't there an "online" file for 
each CPU?

Example:

posidon:davidsen> l /sys/devices/system/cpu/cpu?
/sys/devices/system/cpu/cpu0:
total 0
drwxr-xr-x 5 root    0 Feb  7 12:57 cache
drwxr-xr-x 3 root    0 Mar  7 13:28 cpufreq
-r-------- 1 root 4096 Mar  7 13:28 crash_notes
drwxr-xr-x 2 root    0 Mar  7 13:28 microcode
drwxr-xr-x 2 root    0 Mar  7 13:28 topology

/sys/devices/system/cpu/cpu1:
total 0
drwxr-xr-x 5 root    0 Feb  7 12:57 cache
drwxr-xr-x 3 root    0 Mar  7 13:28 cpufreq
-r-------- 1 root 4096 Mar  7 13:28 crash_notes
drwxr-xr-x 2 root    0 Mar  7 13:28 microcode
-rw-r--r-- 1 root 4096 Mar  7 13:28 online
drwxr-xr-x 2 root    0 Mar  7 13:28 topology


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
