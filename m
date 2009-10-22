Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZJVDpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZJVDpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZJVDpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:45:44 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:17098 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZJVDpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:45:42 -0400
Subject: [PATCH 7/7] Documentation: ABI: /sys/devices/system/cpu/cpu#/cpufreq/
To: randy.dunlap@oracle.com, greg@kroah.com
From: Alex Chiang <achiang@hp.com>
Cc: Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Date: Wed, 21 Oct 2009 21:45:46 -0600
Message-ID: <20091022034546.13399.21222.stgit@bob.kio>
In-Reply-To: <20091022033506.13399.90799.stgit@bob.kio>
References: <20091022033506.13399.90799.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a complex interface and is already described in
Documentation/cpu-freq/, especially in the user-guide.txt file.

No need to copy/paste all that information. Let's just alert the reader
to the presence of the user-guide.

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-devices-system-cpu |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 968d8ba..81e61f5 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -121,6 +121,24 @@ Description:	Discover cpuidle policy and mechanism
 		See files in Documentation/cpuidle/ for more information.
 
 
+What:		/sys/devices/system/cpu/cpu#/cpufreq/*
+Date:		pre-git history
+Contact:	cpufreq@vger.kernel.org
+Description:	Discover and change clock speed of CPUs
+
+		Clock scaling allows you to change the clock speed of the
+		CPUs on the fly. This is a nice method to save battery
+		power, because the lower the clock speed, the less power
+		the CPU consumes.
+
+		There are many knobs to tweak in this directory.
+
+		See files in Documentation/cpu-freq/ for more information.
+
+		In particular, read Documentation/cpu-freq/user-guide.txt
+		to learn how to control the knobs.
+
+
 What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
 Date:      August 2008
 KernelVersion:	2.6.27

