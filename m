Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbYEVOGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbYEVOGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYEVOGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:06:45 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:4823 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYEVOGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:06:44 -0400
Message-Id: <483545B4.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 22 May 2008 08:06:44 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <rostedt@goodmis.org>,
       "Peter Zijlstra" <peterz@infradead.org>, <suresh.b.siddha@intel.com>,
       <aneesh.kumar@linux.vnet.ibm.com>, <dhaval@linux.vnet.ibm.com>,
       <vatsa@linux.vnet.ibm.com>, "David Bahi" <DBahi@novell.com>
Subject: [ANNOUNCE] sched: schedtop utility
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all scheduler developers,
  I had an itch to scratch w.r.t. watching the stats in /proc/schedstats, and it appears that the perl scripts referenced in Documentation/scheduler/sched-stats.txt do not support v14 from HEAD so I whipped up a little utility I call "schedtop".

This utility will process statistics from /proc/schedstat such that the busiest stats will bubble up to the top.  It can alternately be sorted by the largest stat, or by name.  Stats can be included or excluded based on reg-ex pattern matching.

You can download the tarball here:

ftp://ftp.novell.com/dev/ghaskins/schedtop.tar.gz

I have also posted it to the opensuse build service for generating RPMS for a handful of 32/64-bit x86 distros for your convenience:

http://download.opensuse.org/repositories/home:/ghaskins/

(Note that the build is still in progress for some of the favors, so if you do not see the flavor you are looking for, check back in a little while)

Comments/feedback/bug-fixes welcome!

Regards
-Greg

