Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZKQWLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZKQWLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZKQWL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:11:29 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43864 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbZKQWLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:11:24 -0500
Subject: [PATCH 3/3] [CPUFREQ] make internal cpufreq_add_dev_* static
To: davej@redhat.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Date: Tue, 17 Nov 2009 15:11:30 -0700
Message-ID: <20091117221130.25933.92163.stgit@bob.kio>
In-Reply-To: <20091117220729.25933.57884.stgit@bob.kio>
References: <20091117220729.25933.57884.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to export these symbols; make them static.

	cpufreq_add_dev_policy
	cpufreq_add_dev_symlink
	cpufreq_add_dev_interface

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/cpufreq/cpufreq.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0315069..e690211 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -783,7 +783,7 @@ static struct kobj_type ktype_cpufreq = {
  *   0:        Success
  *   Positive: When we have a managed CPU and the sysfs got symlinked
  */
-int cpufreq_add_dev_policy(unsigned int cpu, struct cpufreq_policy *policy,
+static int cpufreq_add_dev_policy(unsigned int cpu, struct cpufreq_policy *policy,
 		struct sys_device *sys_dev)
 {
 	int ret = 0;
@@ -858,7 +858,7 @@ int cpufreq_add_dev_policy(unsigned int cpu, struct cpufreq_policy *policy,
 
 
 /* symlink affected CPUs */
-int cpufreq_add_dev_symlink(unsigned int cpu, struct cpufreq_policy *policy)
+static int cpufreq_add_dev_symlink(unsigned int cpu, struct cpufreq_policy *policy)
 {
 	unsigned int j;
 	int ret = 0;
@@ -885,7 +885,7 @@ int cpufreq_add_dev_symlink(unsigned int cpu, struct cpufreq_policy *policy)
 	return ret;
 }
 
-int cpufreq_add_dev_interface(unsigned int cpu, struct cpufreq_policy *policy,
+static int cpufreq_add_dev_interface(unsigned int cpu, struct cpufreq_policy *policy,
 		struct sys_device *sys_dev)
 {
 	struct cpufreq_policy new_policy;

