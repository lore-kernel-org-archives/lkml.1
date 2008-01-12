Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYALSvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYALSvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbYALSvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:51:11 -0500
Received: from mga10.intel.com ([192.55.52.92]:14124 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755336AbYALSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:51:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,276,1196668800"; 
   d="scan'208";a="286410230"
Message-ID: <47890B65.80804@linux.intel.com>
Date: Sat, 12 Jan 2008 10:48:05 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Andrew.Morton@vax.1wt.eu
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	Andrew Morton
			^-extraneous tokens in address
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	Andrew Morton
			^-extraneous tokens in address
Subject: Top 10 kernel oopses for the week ending January 12th, 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 10 list of the oopses collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 10)

This week, a total of 136 oopses and warnings have been reported,
compared to 46 reports in the previous 7 days.

kerneloops.org news:
	* Based on feedback from last weeks report, the website now tries
	  to also present a disassembled Code: line
	* the kerneloops collection client is now part of Fedora (rawhide)
	  (yum install kerneloops)
	* the kerneloops collection client is now included in Debian testing
	  (apt-get install kerneloops)
	* gentoo has received an updated version of the client


Rank 1: implement (hid code)
	WARN_ON at drivers/hid/hid-core.c:784
	Reported 23 times (39 total reports)
	This appears to be the kernel doing a WARN_ON based on unexpected ioctl() arguments
	More info: http://www.kerneloops.org/search.php?search=implement

Rank 2: __ieee80211_rx
	WARN_ON at net/mac80211/rx.c:1663
	Reported 14 times (25 total reports)
	This is the recurring problem from the last few weeks
	The iwl3945 driver is heavily implicated for this one
	More info: http://www.kerneloops.org/search.php?search=__ieee80211_rx

Rank 3: uart_flush_buffer (caused by bluetooth)
	WARN_ON drivers/serial/serial_core.c:544
	Same issue as a few weeks ago; a fix was posted on LKML already
	Caused by the bluetooth tty layer double closing/freeing the tty
	Reported 8 times (24 total reports)
	More info: http://www.kerneloops.org/search.php?search=uart_flush_buffer

Rank 4: i2c_transfer (by the cx8802/cx22702 driver)
	kernel NULL pointer
	Reported 6 times
	Only reported on 2.6.23.9 so far
	DVB related
	More info: http://www.kerneloops.org/search.php?search=i2c_transfer

Rank 5: __ieee80211_rx_handle_packet (iwl3945)
	WARNING at net/mac80211/rx.c:1693
	Reported 5 times
	Only seen with the iwl3945 driver
	Not the same warning as #2, but the cause may be related
	More info: http://www.kerneloops.org/search.php?search=__ieee80211_rx_handle_packet

Rank 6: NdisDispatchPnp
	Kernel page fault
	Reported 5 times
	Tainted and in the external ndiswrapper binary driver loader
	More info: http://www.kerneloops.org/search.php?search=NdisDispatchPnp

Rank 7: __lock_acquire
	Kernel page fault
	Reported 4 times (14 total reports)
	Reported in 2.5.24-rc5 and rc7 but previously in 2.6.18 timeframe
	Appears to be EXT3 related this time around
	More info: http://bugzilla.kernel.org/show_bug.cgi?id=9718
	More info: http://www.kerneloops.org/search.php?search=__lock_acquire

Rank 8: evdev_disconnect
	Same issue as last week
	Reported 4 times (14 total reports)
	Only seen upto 2.6.23
	Al Viro diagnosed that this got fixed in 2.6.24-rc but the patch wasn't put in 2.6.23-stable
	More info: http://www.kerneloops.org/search.php?search=evdev_disconnect

Rank 9: hfsplus_releasepage
	Kernel null pointer deref
	Reported 3 times
	Only reported for 2.6.24-rc7
	More info: http://www.kerneloops.org/search.php?search=hfsplus_releasepage

Rank 10: cfq_remove_request
	Kernel NULL pointer
	Reported 3 times
	Only reported for 2.6.23
	Reported both from interrupt and process context
	More info: http://www.kerneloops.org/search.php?search=cfq_remove_request


