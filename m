Return-Path: <linux-kernel-owner+w=401wt.eu-S1763304AbZCQLpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304AbZCQLpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZCQLpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:45:10 -0400
Received: from main.gmane.org ([80.91.229.2]:59867 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZCQLpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:45:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh <halesh.s@gmail.com>
Subject: Require more info on Huge pages
Date: Tue, 17 Mar 2009 11:39:33 +0000 (UTC)
Message-ID: <loom.20090317T110726-453@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 121.241.138.250 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi everyone,

While going through Huge pages in Linux, I ran test which is available in
http://lxr.linux.no/linux/Documentation/vm/hugetlbpage.txt. I properly
configured the nr_hugepages and mount points. 

If I interrupt the test while running (ctrl+c) and try to restart the test than
mmap will fail saying No memory to map. This means I am not able to mmap Large
pages further.

This happens only when I interrupt the running test and try to rerun it.

I checked with the /proc/meminfo o/p

MemTotal:      3919196 kB
MemFree:        373460 kB
<snip>
HugePages_Total:  1521
HugePages_Free:   1309
HugePages_Rsvd:   1308                                  **
Hugepagesize:     2048 kB
<snip>

and top command o/p gives like this

<snip>
Mem:   3919196k total,  3546216k used,   372980k free,    14180k buffers
Swap:   610460k total,        0k used,   610460k free,   287656k cached
<snip>

Even process already exited, why does the memory not getting freed??
will large pages are still locked in the memory ? or needs some time or any
method to get broken to small pages and get freed??

There are no other memory eating process running in my system.

Until next reboot the memory is not getting freed.

Please let me know more about this problem.

Thanks,
Halesh

