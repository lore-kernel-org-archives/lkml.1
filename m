Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZJVDpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZJVDpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZJVDpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:45:08 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11316 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZJVDpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:45:07 -0400
Subject: [PATCH 0/7] Documentation: document /sys/devices/system/cpu/
To: randy.dunlap@oracle.com, greg@kroah.com
From: Alex Chiang <achiang@hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
Date: Wed, 21 Oct 2009 21:45:10 -0600
Message-ID: <20091022033506.13399.90799.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Randy,

Not sure who actually maintains Documentation/ABI/; if it's not either of
y'all then please point me at the correct maintainer.

Anyhow, I was proposing some patches to enhance the NUMA sysfs interface:

	http://thread.gmane.org/gmane.linux.kernel.mm/40084/

I documented my changes, but David Rientjes suggested that I take this
as an opportunity to do a more thorough job, so here is an attempt at
doing so by documenting at least the files that I saw on my system. Maybe
there are more that I didn't configure in, but I think this series covers
a good amount.

One thing David suggested was following the sysfs hierarchy a bit more
strictly wrt to the file name in Documentation/ABI. I renamed one existing
file, and then stuck all the new stuff into the result.

I made the decision to keep the granularity at the top level sysfs
CPU interface rather than break out each subdirectory into a separate
file. If that's not ok or preferred, let me know and I can split it out
(but I hope to avoid having to do that).

I split out each group of files into a separate patch, with my best
guess at interested parties cc'ed. That way, they can each bike-shed
me individually. ;)

Thanks,
/ac

---

Alex Chiang (7):
      Documentation: ABI: rename sysfs-devices-cache_disable properly
      Documentation: ABI: document /sys/devices/system/cpu/
      Documentation: ABI: /sys/devices/system/cpu/ topology files
      Documentation: ABI: /sys/devices/system/cpu/cpu#/ topology files
      Documentation: ABI: /sys/devices/system/cpu/sched_[mc|smt]_power_savings
      Documentation: ABI: /sys/devices/system/cpu/cpuidle/
      Documentation: ABI: /sys/devices/system/cpu/cpu#/cpufreq/


 .../ABI/testing/sysfs-devices-cache_disable        |   18 --
 Documentation/ABI/testing/sysfs-devices-system-cpu |  159 ++++++++++++++++++++
 Documentation/cputopology.txt                      |   47 ++++--
 3 files changed, 189 insertions(+), 35 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-devices-cache_disable
 create mode 100644 Documentation/ABI/testing/sysfs-devices-system-cpu

