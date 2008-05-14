Return-Path: <linux-kernel-owner+w=401wt.eu-S1762460AbYENRna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762460AbYENRna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYENRnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:43:21 -0400
Received: from relay4.jackal-net.at ([193.154.151.101]:46408 "EHLO
	vm02.server04.jackal-net.at" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757176AbYENRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:43:20 -0400
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2008 13:43:19 EDT
Message-ID: <482B2108.4090902@jackal-net.at>
Date: Wed, 14 May 2008 19:27:36 +0200
From: Michael Lang <Michael.Lang@jackal-net.at>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel Panic when accessing NFS share and locking files
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Milter: vm02.server04.jackal-net.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we encountered a serious problem, when using Solaris NFS (Server) 
accessing it with a CentOS5.1/RHEL5.1 client.
There are more occurrences of the problem, one i felt over when tried to 
recreate a different one was, that a unprivileged
User is able to Kernel Panic a machine with a few lines of code. I 
tested it with the result that 3 threads requesting a lock
on the same file already cause the kernel panic. Since this is my first 
kernel bug request, and it's at least for my understandig
a security problem, i will provide the code for recreation to a closed 
group only. Please point me to the right group ...

Call Trace:
  [<ffffffff80012323>] __fput+0x94/0x198
  [<ffffffff8002e2d2>] sys_fcntl+0x2d0/0x2dc
  [<ffffffff8005b28d>] tracesys+0xd5/0xe0
 Code: 0f 0b 68 8a de 28 80 c2 c7 07 48 89 c3 48 8b 03 48 85 c0 75
 RIP  [<ffffffff80027073>] locks_remove_flock+0xe4/0x122
 RSP <ffff81000be87e48>


regards
Michael Lang
