Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYD2M5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYD2M5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYD2M5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:57:16 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:42049 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYD2M5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:57:15 -0400
Date: Tue, 29 Apr 2008 18:26:59 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [PATCH 0/8] CPU-Hotplug: Fix CPU-Hotplug <--> cpufreq locking
	dependency
Message-ID: <20080429125659.GA23562@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

A couple of months ago Zdenek Kabelac had reported a Circular locking
dependency in resume, which was related to the locking dependency
between the cpufreq and CPU-Hotplug subsystems.

http://lkml.org/lkml/2008/2/26/479

This patchset aggregates the various patches that have been posted in
the recent past, to solve this problem.

There are a few more TODO items in CPU-Hotplug , unrelated to
this problem, that cropped up in the various discussions.
They will be posted in a seperate thread.

The patchstack has been lightly tested on a 4-way x86 machine with
CPU-Hotplug running in parallel with kernbench and changing cpufreq
governors simultaneously.

Awaiting your feedback,
gautham
