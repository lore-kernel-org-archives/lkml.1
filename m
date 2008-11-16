Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYKPVdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYKPVdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYKPVdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:33:16 -0500
Received: from hpsmtp-eml14.KPNXCHANGE.COM ([213.75.38.114]:25495 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbYKPVdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:33:16 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: broken ownership of /proc/sys/ files on 2.6.27
Date: Sun, 16 Nov 2008 22:33:12 +0100
User-Agent: KMail/1.9.9
Cc: Peter Palfrader <peter@palfrader.org>
References: <20081116205922.GI28958@anguilla.noreply.org>
In-reply-To: <20081116205922.GI28958@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811162233.13339.elendil@planet.nl>
X-OriginalArrivalTime: 16 Nov 2008 21:33:14.0093 (UTC) FILETIME=[EE55B9D0:01C94832]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Confirmed for 2.6.28-rc5.

$ uname -a
Linux faramir 2.6.28-rc5 #55 SMP Sun Nov 16 01:23:28 CET 2008 x86_64 GNU/Linux

$ ls -l /proc/sys/kernel/
total 0
-rw-r--r-- 1 fjp      fjp      0 2008-11-16 22:28 acct
-rw-r--r-- 1 root     root     0 2008-11-16 22:28 acpi_video_flags
-rw-r--r-- 1 root     root     0 2008-11-16 22:28 auto_msgmni
-r--r--r-- 1 root     root     0 2008-11-16 22:28 bootloader_type
-rw------- 1 fjp      fjp      0 2008-11-16 22:28 cad_pid
-rw-r--r-- 1 root     root     0 2008-11-16 22:28 compat-log
[...]
-rw-r--r-- 1 fjp      fjp      0 2008-11-16 22:28 latencytop
-rw-r--r-- 1 root     root     0 2008-11-16 22:28 max_lock_depth
-rw-r--r-- 1 logcheck logcheck 0 2008-11-16 16:07 modprobe
[...]
dr-xr-xr-x 0 root     root     0 2008-11-16 22:28 sched_domain
-rw-r--r-- 1 logcheck logcheck 0 2008-11-16 22:28 sched_features
-rw-r--r-- 1 logcheck logcheck 0 2008-11-16 22:28 sched_latency_ns
-rw-r--r-- 1 logcheck logcheck 0 2008-11-16 22:28 sched_migration_cost
-rw-r--r-- 1 root     root     0 2008-11-16 22:28 sched_min_granularity_ns
-rw-r--r-- 1 logcheck logcheck 0 2008-11-16 22:28 sched_nr_migrate
-rw-r--r-- 1 logcheck logcheck 0 2008-11-16 22:28 sched_rt_period_us
-rw-r--r-- 1 fjp      fjp      0 2008-11-16 22:28 sched_rt_runtime_us
