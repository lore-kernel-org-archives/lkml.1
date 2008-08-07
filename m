Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYHGHD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYHGHD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 03:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYHGHDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 03:03:51 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:53698 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032AbYHGHDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 03:03:51 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
Date: Thu, 07 Aug 2008 17:03:38 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <i97l94d25m40143e14rgi6rth9vamat5t5@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Check this out, look at the kthreadd number, that's not right?  Only 
turned the machine on this morning, not doing time travel this month ;)

~$ top
top - 16:58:07 up 10:57,  9 users,  load average: 1.64, 1.67, 1.67
Tasks: 103 total,   4 running,  99 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,100.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2049532k total,   882924k used,  1166608k free,    69464k buffers
Swap:  4112560k total,        0k used,  4112560k free,   327864k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
16757 grant     20   0 18892 1244  932 R  301  0.1   0:07.03 top
    1 root      20   0  3840  624  528 S    0  0.0   0:00.69 init
    2 root      15  -5     0    0    0 S    0  0.0  5124095h kthreadd
                                                    ^^^^^^^^^^^^^^^^^
...
  637 root      15  -5     0    0    0 S    0  0.0   0:00.00 scsi_eh_5
~$ uname -r
2.6.27-rc2a

config + dmesg at:
  http://bugsplatter.id.au/test/boxen/pooh64/config-2.6.27-rc2a.gz
  http://bugsplatter.id.au/test/boxen/pooh64/dmesg-2.6.27-rc2a.gz

Grant.
