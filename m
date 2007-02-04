Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbXBDWzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbXBDWzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 17:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXBDWzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 17:55:43 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:59469 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbXBDWzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 17:55:42 -0500
Date: Sun, 4 Feb 2007 23:55:41 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: regarding generic AIO, async syscalls precedent + some benchmarks by lighttpd
Message-ID: <20070204225541.GA18359@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Zach Brown <zach.brown@oracle.com>,
	Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, linux-aio@kvack.org,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From two comments posted to my "blog"
http://blog.netherlabs.nl/articles/2007/02/04/a-synchronous-programming

Excerpted from the diary of Dragonfly BSD,
http://www.dragonflybsd.org/status/diary.shtml 

 Remove the asynchronous syscall interface. It was an idea before its time.
 However, keep the formalization of the syscall arguments structures.

The original async syscall interface was committed in
http://leaf.dragonflybsd.org/mailarchive/commits/2004-08/msg00067.html

Comment by Jan Kneschke, lighttpd developer, noting the lack of and need for
aio_stat():

 Reading this article feels like reading the code I wrote in the last days
 for lighttpd. Even if the network-io was async since the start
 (non-blocking), the file-io wasn't. Worst of all was the stat() syscall
 which doesn't have a async interface even in POSIX AIO. So it had to be
 implemented with threads on our own. At http://www.lighttpd.net/benchmark/
 you can see the impact of async vs. blocking syscalls.

Perhaps relevant.

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
