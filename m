Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYDDRVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYDDRVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 13:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYDDRV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 13:21:27 -0400
Received: from mga06.intel.com ([134.134.136.21]:54156 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751167AbYDDRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 13:21:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,605,1199692800"; 
   d="scan'208";a="366222915"
Message-ID: <47F661C8.6000604@linux.intel.com>
Date: Fri, 04 Apr 2008 10:13:44 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Kernel Warning/Oops report for the week of April 4th, 2008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a general note, the hottest issues from last week got fixed, most of the
remaining issues are from the Fedora 9 (beta) kernels, specifically from various patches
that will otherwise go into the next merge window.



The http://www.kerneloops.org website collects kernel oops and
warning reports from various mailing lists and bugzillas as well as
with a client users can install to auto-submit oopses.
Below is a top 10 list of the oopses collected in the last 7 days.
(Reports prior to 2.6.23 have been omitted in collecting the top 10)

This week, a total of 881 oopses and warnings have been reported,
compared to 455 reports in the previous week.


Rank 1: input_release_device
	Reported 245 times (489 total reports)
	This issue got fixed just before the 2.6.25-rc8 release; no sightings have been seen after that.
	More info: http://www.kerneloops.org/searchweek.php?search=input_release_device

Rank 2: radeon_vblank_crtc_set
	Reported 45 times (70 total reports)
	This issue seems to be specific to the radeon driver in Fedora 9 (beta)
	More info: http://www.kerneloops.org/searchweek.php?search=radeon_vblank_crtc_set

Rank 3: __ieee80211_rx (rt2x00)
	Reported 44 times (117 total reports)
	This issue is specific to the rt2x00 driver in wireless.git; it'll be important to get
	this driver fixed before the 2.6.26 merge window
	(The Fedora 9 beta kernels currently include wireless.git)
	More info: http://www.kerneloops.org/search.php?search=__ieee80211_rx

Rank 4: sysctl_check_lookup (parport driver)
	Reported 44 times (99 total reports)
	This is only for 2.6.24 kernels and got fixed for 2.6.25
	More info: http://www.kerneloops.org/search.php?search=sysctl_check_lookup

Rank 5: rt2x00usb_vendor_request_buff
	Reported 42 times
	This issue is specific to the rt2x00 driver in wireless.git; it'll be important to get
	this driver fixed before the 2.6.26 merge window
	More info: http://www.kerneloops.org/search.php?search=rt2x00usb_vendor_request_buff

Rank 6: rtnetlink_rcv
	Reported 28 times
	This issue is specific to the rt2x00 driver in wireless.git; it'll be important to get
	this driver fixed before the 2.6.26 merge window
	More info: http://www.kerneloops.org/search.php?search=rtnetlink_rcv

Rank 7: do_sys_open
	Reported 26 times (65 total reports)
	This issue is specific to the nouveau driver in Fedora 9 (beta) which returns
	1 and not -1 for a few error conditions, confusing IS_ERR / PTR_ERR
	More info: http://www.kerneloops.org/search.php?search=do_sys_open

Rank 8: schedule_timeout (rt2x00usb_vendor_request)
	Reported 25 times (28 total reports)
	This issue is specific to the rt2x00 driver in wireless.git; it'll be important to get
	this driver fixed before the 2.6.26 merge window
	More info: http://www.kerneloops.org/search.php?search=schedule_timeout

Rank 9: uvc_get_video_ctrl
	Reported 24 times (105 total reports)
	This is an out of tree driver added to the Fedora 9 (beta) kernel; this seems to be
	a 64 bit specific bug
	More info: http://www.kerneloops.org/search.php?search=uvc_get_video_ctrl
	More info: https://bugzilla.redhat.com/show_bug.cgi?id=439643

Rank 10: set_dentry_child_flags
	Reported 24 times (511 total reports)
	This bug is specific to 2.6.24 and earlier and got fixed by Nick Piggin for 2.6.25
	More info: http://www.kerneloops.org/search.php?search=set_dentry_child_flags

Rank 11: snd_es1968_ac97_read
	Reported 24 times (38 total reports)
	This is a sleeping-while-holding-a-spinlock bug;
	Fix at: http://www.spinics.net/lists/kernel/msg709389.html (included in -mm)
	More info: http://www.kerneloops.org/search.php?search=snd_es1968_ac97_read
