Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZJVVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZJVVrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbZJVVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:47:20 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:41291 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZJVVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:47:19 -0400
Date: Thu, 22 Oct 2009 14:45:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: greg@kroah.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
Subject: Re: [PATCH 0/7] Documentation: document /sys/devices/system/cpu/
Message-Id: <20091022144530.d105c87f.randy.dunlap@oracle.com>
In-Reply-To: <20091022033506.13399.90799.stgit@bob.kio>
References: <20091022033506.13399.90799.stgit@bob.kio>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AE0D2BE.0034:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 21:45:10 -0600 Alex Chiang wrote:

> Hi Greg, Randy,
> 
> Not sure who actually maintains Documentation/ABI/; if it's not either of
> y'all then please point me at the correct maintainer.
> 
> Anyhow, I was proposing some patches to enhance the NUMA sysfs interface:
> 
> 	http://thread.gmane.org/gmane.linux.kernel.mm/40084/

Greg does, but he's in Japan or traveling this week...


> I documented my changes, but David Rientjes suggested that I take this
> as an opportunity to do a more thorough job, so here is an attempt at
> doing so by documenting at least the files that I saw on my system. Maybe
> there are more that I didn't configure in, but I think this series covers
> a good amount.

Thanks for doing this.

> One thing David suggested was following the sysfs hierarchy a bit more
> strictly wrt to the file name in Documentation/ABI. I renamed one existing
> file, and then stuck all the new stuff into the result.
> 
> I made the decision to keep the granularity at the top level sysfs
> CPU interface rather than break out each subdirectory into a separate
> file. If that's not ok or preferred, let me know and I can split it out
> (but I hope to avoid having to do that).
> 
> I split out each group of files into a separate patch, with my best
> guess at interested parties cc'ed. That way, they can each bike-shed
> me individually. ;)
> 
> Thanks,
> /ac
> 
> ---
> 
> Alex Chiang (7):
>       Documentation: ABI: rename sysfs-devices-cache_disable properly
>       Documentation: ABI: document /sys/devices/system/cpu/
>       Documentation: ABI: /sys/devices/system/cpu/ topology files
>       Documentation: ABI: /sys/devices/system/cpu/cpu#/ topology files
>       Documentation: ABI: /sys/devices/system/cpu/sched_[mc|smt]_power_savings
>       Documentation: ABI: /sys/devices/system/cpu/cpuidle/
>       Documentation: ABI: /sys/devices/system/cpu/cpu#/cpufreq/
> 
> 
>  .../ABI/testing/sysfs-devices-cache_disable        |   18 --
>  Documentation/ABI/testing/sysfs-devices-system-cpu |  159 ++++++++++++++++++++
>  Documentation/cputopology.txt                      |   47 ++++--
>  3 files changed, 189 insertions(+), 35 deletions(-)
>  delete mode 100644 Documentation/ABI/testing/sysfs-devices-cache_disable
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-system-cpu


---
~Randy
