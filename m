Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbXLNSt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbXLNSt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXLNStT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:49:19 -0500
Received: from mga10.intel.com ([192.55.52.92]:35157 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbXLNStS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:49:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,168,1196668800"; 
   d="scan'208";a="238692896"
Message-ID: <4762CF8C.90808@linux.intel.com>
Date: Fri, 14 Dec 2007 10:46:36 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation>, protasnb@gmail.com
Subject: Top kernel oopses/warnings this week
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The http://www.kerneloops.org website collects kernel oops and warning reports from various mailing lists and bugzillas; below is a top 10 
list of the oopses collected in the last 7 days. (Reports prior to 2.6.23 have been omitted in collecting the top 10)

This is the first such report that I'm posting; Please let me know if this is useful or not.

hid_output_report warning
	Warning at drivers/hid/hid-core.c:784 implement()
	16 times last week
	<no specific version information available>
	More Info: http://www.kerneloops.org/search.php?search=implement

softlockup in tick_broadcast_oneshot_control
	3 times last week
	Only seen in 2.6.24-rc4 so far
	More Info: http://www.kerneloops.org/oops.php?number=2409
	
hiddev_ioctl crash
	3 times last week
	Only seen in 2.6.24-rc3 so far
	More Info: http://www.kerneloops.org/oops.php?number=2428
	
shrink_dcache_for_umount_subtree crash
	BUG at fs/dcache.c:595
	2 times last week
	Has been seen as far back as 2.6.18
	More Info: http://www.kerneloops.org/oops.php?number=2365
	More Info: http://www.kerneloops.org/search.php?search=shrink_dcache_for_umount_subtree
	
cpufreq_remove_dev crash
	BUG at drivers/cpufreq/cpufreq.c:1060
	2 times last week
	Has been reported only for 2.6.24-rc4
	More Info: http://www.kerneloops.org/search.php?search=cpufreq_remove_dev
	More Info: http://www.kerneloops.org/oops.php?number=2458
	
journal_dirty_data crash (tainted)
	BUG at fs/jbd/transaction.c:983	
	2 times last week
	Has been reported only in 2.6.23.9
	http://www.kerneloops.org/search.php?search=journal_dirty_data
	
tcp_fastretrans_alert
	WARNING at net/ipv4/tcp_input.c:2533 tcp_fastretrans_alert()
	2 times last week
	Has been reported in 2.6.24-rc4 and -rc5
	More Info: http://www.kerneloops.org/search.php?search=tcp_fastretrans_alert	
	
tcp_sacktag_one
	WARNING at net/ipv4/tcp_input.c:1280 tcp_sacktag_one()	
	Reported once
	Has only been seen in -rc5 so far
	More Info: http://www.kerneloops.org/search.php?search=tcp_sacktag_one
	
simple_map_write (MTD)
	kernel crash
	Reported once this week on 2.6.24-rc5
	Has been seen as far back as 2.6.17
	More Info: http://www.kerneloops.org/search.php?search=simple_map_write
	
tcp_sacktag_walk	
	WARNING at net/ipv4/tcp_input.c:1280
	Reported once on 2.6.24-rc5
	Has been seen only on 2.6.24-rc5
	More Info: http://www.kerneloops.org/search.php?search=tcp_sacktag_walk
