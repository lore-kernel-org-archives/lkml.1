Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYKPVhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYKPVhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYKPVg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:36:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:32896 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbYKPVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:36:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wCVsczzsE+ETr2P8TNsZoSy7uCcIcb50pHTPDiHRrNmLs9p96vJ6blPj07CkPsQDj1
         HL7j1aF0nHinf+WR2cSHu6GnG6frMZm+Tn+ATmw6n6fR3/+JBK39g8VG3Z4xif0CMpVQ
         jj6wItWwxvc08nXf6WfmHn3o4KZMFbfrw7ZsQ=
Message-ID: <49209274.2030904@gmail.com>
Date: Sun, 16 Nov 2008 23:36:52 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, Peter Palfrader <peter@palfrader.org>
Subject: Re: broken ownership of /proc/sys/ files on 2.6.27
References: <20081116205922.GI28958@anguilla.noreply.org> <200811162233.13339.elendil@planet.nl>
In-Reply-To: <200811162233.13339.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Confirm too:

maxim@mobile:~$ ls -l /proc/sys/kernel/
total 0
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 acct
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 acpi_video_flags
-rw-r--r-- 1 maxim maxim 0 2008-11-16 23:35 auto_msgmni
-r--r--r-- 1 root  root  0 2008-11-16 23:35 bootloader_type
-rw------- 1 root  root  0 2008-11-16 23:35 cad_pid
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 core_pattern
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 core_uses_pid
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 ctrl-alt-del
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 domainname
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 ftrace_enabled
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 hostname
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 hotplug
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 hung_task_check_count
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 hung_task_timeout_secs
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 hung_task_warnings
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 io_delay_type
dr-xr-xr-x 0 root  root  0 2008-11-16 23:35 keys
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 kstack_depth_to_print
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 maps_protect
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 max_lock_depth
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 modprobe
-rw-r--r-- 1 maxim maxim 0 2008-11-16 23:35 msgmax
-rw-r--r-- 1 maxim maxim 0 2008-11-16 23:35 msgmnb
-rw-r--r-- 1 maxim maxim 0 2008-11-16 23:35 msgmni
-r--r--r-- 1 root  root  0 2008-11-16 15:23 ngroups_max
-rw-r--r-- 1 maxim maxim 0 2008-11-16 23:35 nmi_watchdog
-r--r--r-- 1 root  root  0 2008-11-16 23:35 osrelease
-r--r--r-- 1 root  root  0 2008-11-16 23:35 ostype
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 overflowgid
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 overflowuid
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 panic
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 panic_on_oops
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 panic_on_unrecovered_nmi
-rw-r--r-- 1 maxim maxim 0 2008-11-16 17:27 pid_max
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 poweroff_cmd
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 print-fatal-signals
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 printk
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 printk_ratelimit
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 printk_ratelimit_burst
dr-xr-xr-x 0 maxim maxim 0 2008-11-16 23:35 pty
dr-xr-xr-x 0 root  root  0 2008-11-16 23:35 random
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 randomize_va_space
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 real-root-dev
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_child_runs_first
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_compat_yield
dr-xr-xr-x 0 maxim maxim 0 2008-11-16 23:35 sched_domain
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_features
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_latency_ns
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_migration_cost
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_min_granularity_ns
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_nr_migrate
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_rt_period_us
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_rt_runtime_us
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_shares_ratelimit
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sched_wakeup_granularity_ns
-rw-r--r-- 1 maxim maxim 0 2008-11-16 23:35 sem
-r--r--r-- 1 root  root  0 2008-11-16 23:35 sg-big-buff
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 shmall
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 shmmax
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 shmmni
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 softlockup_panic
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 softlockup_thresh
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 sysrq
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 tainted
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 threads-max
-rw-r--r-- 1 root  root  0 2008-11-16 23:35 unknown_nmi_panic
-r--r--r-- 1 root  root  0 2008-11-16 23:35 version
maxim@mobile:~$ 

