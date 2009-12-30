Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZL3K7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZL3K7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 05:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZL3K7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 05:59:40 -0500
Received: from 62.1.125.199.dsl.dyn.forthnet.gr ([62.1.125.199]:33416 "EHLO
	poseidon.vergina.dyndns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbZL3K7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 05:59:39 -0500
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Dec 2009 05:59:39 EST
Message-ID: <4B3B3043.20400@asyr.hopto.org>
Date: Wed, 30 Dec 2009 12:49:39 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091229 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: gentoo-user@lists.gentoo.org, LKML <linux-kernel@vger.kernel.org>
Subject: RAM installed vs reported
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a netbook (Acer Aspire One A110L) and installed a 1GB DDR2 in the
available slot, for a total of 1.5GB or RAM.
The BIOS reports it as 1.5GB and so does grml linux (booting from usb),
but the installed gentoo linux reports only 904600 kB:

# free
             total       used       free     shared    buffers     cached
Mem:        904600      82316     822284          0       9752      37712
-/+ buffers/cache:      34852     869748
Swap:      1638588          0    1638588

# cat /proc/meminfo
MemTotal:         904600 kB
MemFree:          822284 kB
Buffers:            9752 kB
Cached:            37712 kB
SwapCached:            0 kB
Active:            32232 kB
Inactive:          28780 kB
Active(anon):      13848 kB
Inactive(anon):        0 kB
Active(file):      18384 kB
Inactive(file):    28780 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       1638588 kB
SwapFree:        1638588 kB
Dirty:                 4 kB
Writeback:             0 kB
AnonPages:         13548 kB
Mapped:            11256 kB
Shmem:               300 kB
Slab:              10356 kB
SReclaimable:       6132 kB
SUnreclaim:         4224 kB
KernelStack:        1424 kB
PageTables:          892 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2090888 kB
Committed_AS:      73552 kB
VmallocTotal:     122880 kB
VmallocUsed:        9688 kB
VmallocChunk:     109832 kB
DirectMap4k:       11832 kB
DirectMap4M:      905216 kB

I suspect it has to do with my kernel (2.6.32-gentoo-r1) configuration,
but do not know where to look.
Any suggestions ?


