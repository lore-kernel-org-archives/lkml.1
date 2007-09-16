Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbXIPNCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbXIPNCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 09:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbXIPNCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 09:02:33 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:50426 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731AbXIPNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 09:02:33 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: TSC && HPET calibration
Date: Sun, 16 Sep 2007 15:02:30 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709161502.30533.elendil@planet.nl>
X-OriginalArrivalTime: 16 Sep 2007 13:02:30.0716 (UTC) FILETIME=[D71237C0:01C7F861]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the same error as reported by Sami Farin earlier today [1], but
from my logs I can see that the issue is intermittent (2/3 failures). The
logs indicate that the issue was introduced with 2.6.22 as TSC sync was
correct for all boots with 2.6.21-6.

My system is also Pentium D: Intel(R) Pentium(R) D CPU 3.20GHz

Cheers,
Frans Pop

[1] http://lkml.org/lkml/2007/9/16/34

Jul 12 10:54:37 faramir kernel: Linux version 2.6.21-2-amd64 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Tue Jul 10 21:39:38 UTC 2007
Jul 12 10:54:37 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 13 15:24:10 faramir kernel: Linux version 2.6.21-2-amd64 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Tue Jul 10 21:39:38 UTC 2007
Jul 13 15:24:10 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 14 14:22:11 faramir kernel: Linux version 2.6.21-2-amd64 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Tue Jul 10 21:39:38 UTC 2007
Jul 14 14:22:11 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 14 16:42:12 faramir kernel: Linux version 2.6.21-2-amd64 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Tue Jul 10 21:39:38 UTC 2007
Jul 14 16:42:12 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 14 19:32:17 faramir kernel: Linux version 2.6.21-2-amd64 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Tue Jul 10 21:39:38 UTC 2007
Jul 14 19:32:17 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 15 13:44:51 faramir kernel: Linux version 2.6.21-2-amd64 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Tue Jul 10 21:39:38 UTC 2007
Jul 15 13:44:51 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 16 18:16:52 faramir kernel: Linux version 2.6.21-2-amd64 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Tue Jul 10 21:39:38 UTC 2007
Jul 16 18:16:52 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 16 18:53:26 faramir kernel: Linux version 2.6.21-2-amd64 (Debian 2.6.21-6) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Tue Jul 10 21:39:38 UTC 2007
Jul 16 18:53:26 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.

Jul 17 21:05:13 faramir kernel: Linux version 2.6.22-1-amd64 (Debian 2.6.22-1) (waldi@debian.org) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Mon Jul 16 00:30:42 UTC 2007
Jul 17 21:05:13 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Jul 17 21:05:13 faramir kernel: Measured 40 cycles TSC warp between CPUs, turning off TSC clock.
Jul 17 21:05:13 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed

Aug 18 07:30:55 faramir kernel: Linux version 2.6.23-rc3 (root@faramir) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Mon Aug 13 17:24:51 CEST 2007
Aug 18 07:30:55 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Aug 18 07:30:55 faramir kernel: Measured 24 cycles TSC warp between CPUs, turning off TSC clock.
Aug 18 07:30:55 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Aug 19 06:59:50 faramir kernel: Linux version 2.6.23-rc3 (root@faramir) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Mon Aug 13 17:24:51 CEST 2007
Aug 19 06:59:50 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Aug 19 06:59:50 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Aug 19 06:59:50 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Aug 20 07:47:51 faramir kernel: Linux version 2.6.23-rc3 (root@faramir) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Mon Aug 13 17:24:51 CEST 2007
Aug 20 07:47:51 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Aug 21 09:16:46 faramir kernel: Linux version 2.6.23-rc3 (root@faramir) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Mon Aug 13 17:24:51 CEST 2007
Aug 21 09:16:46 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Aug 22 10:27:29 faramir kernel: Linux version 2.6.23-rc3 (root@faramir) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Mon Aug 13 17:24:51 CEST 2007
Aug 22 10:27:29 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Aug 22 10:27:29 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Aug 22 10:27:29 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Aug 23 09:52:29 faramir kernel: Linux version 2.6.23-rc3 (root@faramir) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Mon Aug 13 17:24:51 CEST 2007
Aug 23 09:52:30 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Aug 23 09:52:30 faramir kernel: Measured 40 cycles TSC warp between CPUs, turning off TSC clock.
Aug 23 09:52:30 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Aug 28 18:49:04 faramir kernel: Linux version 2.6.23-rc3 (root@faramir) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP Mon Aug 13 17:24:51 CEST 2007
Aug 28 18:49:04 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Aug 28 18:49:04 faramir kernel: Measured 40 cycles TSC warp between CPUs, turning off TSC clock.
Aug 28 18:49:04 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Aug 29 19:53:26 faramir kernel: Linux version 2.6.23-rc4 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Tue Aug 28 20:42:39 CEST 2007
Aug 29 19:53:26 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Aug 30 18:04:20 faramir kernel: Linux version 2.6.23-rc4 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Tue Aug 28 20:42:39 CEST 2007
Aug 30 18:04:20 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Aug 30 18:04:20 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Aug 30 18:04:20 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Aug 31 17:40:28 faramir kernel: Linux version 2.6.23-rc4 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Tue Aug 28 20:42:39 CEST 2007
Aug 31 17:40:28 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Aug 31 17:40:28 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Aug 31 17:40:28 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep  1 18:36:51 faramir kernel: Linux version 2.6.23-rc4 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Tue Aug 28 20:42:39 CEST 2007
Sep  1 18:36:51 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep  1 18:36:51 faramir kernel: Measured 40 cycles TSC warp between CPUs, turning off TSC clock.
Sep  1 18:36:51 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep  2 13:29:56 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Sat Sep 1 20:51:22 CEST 2007
Sep  2 13:29:56 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep  2 13:29:56 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Sep  2 13:29:56 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep  3 11:07:19 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Sat Sep 1 20:51:22 CEST 2007
Sep  3 11:07:19 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Sep  4 15:33:24 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Sat Sep 1 20:51:22 CEST 2007
Sep  4 15:33:24 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Sep  5 14:24:12 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Sat Sep 1 20:51:22 CEST 2007
Sep  5 14:24:12 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep  5 14:24:12 faramir kernel: Measured 40 cycles TSC warp between CPUs, turning off TSC clock.
Sep  5 14:24:12 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep  6 07:10:28 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP Sat Sep 1 20:51:22 CEST 2007
Sep  6 07:10:28 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep  6 07:10:28 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Sep  6 07:10:28 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep  7 16:18:01 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Thu Sep 6 17:00:32 CEST 2007
Sep  7 16:18:01 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep  7 16:18:01 faramir kernel: Measured 248 cycles TSC warp between CPUs, turning off TSC clock.
Sep  7 16:18:01 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep  7 21:09:15 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Thu Sep 6 17:00:32 CEST 2007
Sep  7 21:09:15 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep  7 21:09:15 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Sep  7 21:09:15 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep  9 12:25:29 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Thu Sep 6 17:00:32 CEST 2007
Sep  9 12:25:29 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Sep 11 07:15:52 faramir kernel: Linux version 2.6.23-rc5 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Thu Sep 6 17:00:32 CEST 2007
Sep 11 07:15:52 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep 11 07:15:52 faramir kernel: Measured 40 cycles TSC warp between CPUs, turning off TSC clock.
Sep 11 07:15:52 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep 12 08:57:51 faramir kernel: Linux version 2.6.23-rc6 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Tue Sep 11 15:10:11 CEST 2007
Sep 12 08:57:51 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep 12 08:57:51 faramir kernel: Measured 40 cycles TSC warp between CPUs, turning off TSC clock.
Sep 12 08:57:51 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep 13 01:38:51 faramir kernel: Linux version 2.6.23-rc6 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Tue Sep 11 15:10:11 CEST 2007
Sep 13 01:38:52 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep 13 01:38:52 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Sep 13 01:38:52 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep 14 01:03:48 faramir kernel: Linux version 2.6.23-rc6 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Tue Sep 11 15:10:11 CEST 2007
Sep 14 01:03:48 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Sep 14 08:52:46 faramir kernel: Linux version 2.6.23-rc6 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Tue Sep 11 15:10:11 CEST 2007
Sep 14 08:52:46 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep 14 08:52:46 faramir kernel: Measured 48 cycles TSC warp between CPUs, turning off TSC clock.
Sep 14 08:52:46 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
Sep 15 09:05:55 faramir kernel: Linux version 2.6.23-rc6 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Tue Sep 11 15:10:11 CEST 2007
Sep 15 09:05:55 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Sep 16 11:37:36 faramir kernel: Linux version 2.6.23-rc6 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Tue Sep 11 15:10:11 CEST 2007
Sep 16 11:37:36 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Sep 16 13:57:04 faramir kernel: Linux version 2.6.23-rc6 (root@faramir) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #2 SMP Tue Sep 11 15:10:11 CEST 2007
Sep 16 13:57:04 faramir kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Sep 16 13:57:04 faramir kernel: Measured 56 cycles TSC warp between CPUs, turning off TSC clock.
Sep 16 13:57:04 faramir kernel: Marking TSC unstable due to check_tsc_sync_source failed
