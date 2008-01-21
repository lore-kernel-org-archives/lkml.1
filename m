Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYAURA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYAURA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYAURAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:00:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:41689 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYAURAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:00:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,227,1199692800"; 
   d="scan'208";a="292128221"
Message-ID: <4794CF82.8080003@linux.intel.com>
Date: Mon, 21 Jan 2008 08:59:46 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Top bugreports for the week prior to January 21st 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 9 list of the oopses collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 9)

This week, a total of 123 oopses and warnings have been reported.


Rank 1: implement
	WARN_ON in drivers/hid/hid-core.c:785
	Reported 30 times (92 total reports)
	Same issue as last week; the WARN_ON is in response to an invalid command
	sent from a (common) userspace application. This is clearly an obnoxious
	thing to do; an -EINVAL return from the ioctl() would have been nicer
	More info: http://www.kerneloops.org/search.php?search=implement

Rank 2: __ieee80211_rx_handle_packet
	WARN_ON in net/mac80211/rx.c:1702
	Reported 14 times (20 total reports)
	This is a bug in the iwl3945 driver and is already being worked on
	More info: http://www.kerneloops.org/search.php?search=__ieee80211_rx_handle_packet

Rank 3: set_dentry_child_flags
	WARN_ON in fs/inotify.c:172
	Only reported for pre-2.6.24 kernels
	Reported 9 times (15 total reports)
	Is inotify related
	More info: http://www.kerneloops.org/search.php?search=set_dentry_child_flags

Rank 4: uart_flush_buffer
	WARN_ON in drivers/serial/serial_core.c:544
	Reported 6 times (30 total reports)
	This is an old known issue; Andrew has a patch for it in -mm
	More info: http://www.kerneloops.org/search.php?search=uart_flush_buffer

Rank 5: __make_request
	This is a spinlock lockup when using the Oracle database application
	Reported 4 times (17 total reports)
	Sounds like something for Jens Axboe to chase down
	More info: http://www.kerneloops.org/search.php?search=__make_request

Rank 6: cache_grow
	WARN_ON in mm/slab.c:2779
	Reported 3 times, but only for PPC64 2.6.24-rc8
	More info: http://www.kerneloops.org/search.php?search=cache_grow

Rank 7: default_idle
	Reported 3 times (7 total reports)
	As always, crashes in the idle loop tend to be a symptom for hardware issues
	(Not only is the most wallclock time spent here, it's also a scenario for big
	swings in power consumption)
	More info: http://www.kerneloops.org/search.php?search=default_idle

Rank 8: down_read
	Only happened with a tripple-tainted kernel; probably not worth spending time on
	Reported 2 times (5 total reports)
	More info: http://www.kerneloops.org/search.php?search=down_read

Rank 9: acpi_idle_enter_bm
	As always, crashes in the idle loop tend to be a symptom for hardware issues
	(Not only is the most wallclock time spent here, it's also a scenario for big
	Reported 2 times (5 total reports)
	More info: http://www.kerneloops.org/search.php?search=acpi_idle_enter_bm
