Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYCUX4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYCUX4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYCUX4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:56:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41599 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYCUX4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:56:35 -0400
Date: Fri, 21 Mar 2008 16:56:31 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: [PATCH] cpufreq: Document the currently undocumented parts of the
	sysfs interface
Message-ID: <20080321235631.GS5529@tree.beaverton.ibm.com>
References: <20080321004354.GQ5529@tree.beaverton.ibm.com> <20080321154124.668969a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321154124.668969a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 03:41:24PM -0700, Andrew Morton wrote:

> I was going to ding you for not updating the kernel->userspace API
> documentation.  But it seems that none of this interface is documented
> anyway :(

Actually, I deserve the ding, for there _is_ a description of some of
the sysfs files.  However, there are some that are not mentioned in the
documentation, so add them to the user's guide.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/cpu-freq/user-guide.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/cpu-freq/user-guide.txt b/Documentation/cpu-freq/user-guide.txt
index af3b925..6c442d8 100644
--- a/Documentation/cpu-freq/user-guide.txt
+++ b/Documentation/cpu-freq/user-guide.txt
@@ -154,6 +154,11 @@ scaling_governor,		and by "echoing" the name of another
 				that some governors won't load - they only
 				work on some specific architectures or
 				processors.
+
+cpuinfo_cur_freq :		Current speed of the CPU, in KHz.
+
+scaling_available_frequencies : List of available frequencies, in KHz.
+
 scaling_min_freq and
 scaling_max_freq		show the current "policy limits" (in
 				kHz). By echoing new values into these
@@ -162,6 +167,15 @@ scaling_max_freq		show the current "policy limits" (in
 				first set scaling_max_freq, then
 				scaling_min_freq.
 
+affected_cpus :			List of CPUs that require software coordination
+				of frequency.
+
+related_cpus :			List of CPUs that need some sort of frequency
+				coordination, whether software or hardware.
+
+scaling_driver :		Hardware driver for cpufreq.
+
+scaling_cur_freq :		Current frequency of the CPU, in KHz.
 
 If you have selected the "userspace" governor which allows you to
 set the CPU operating frequency to a specific value, you can read out
