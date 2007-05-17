Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbXEQOa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbXEQOa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbXEQOau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:30:50 -0400
Received: from exchange.vrs-soft.com ([66.184.242.173]:3014 "EHLO
	exchange.vrs-soft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbXEQOas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:30:48 -0400
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 10:30:48 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: box reboots when using a non-default memory split and highmem
Date: Thu, 17 May 2007 10:18:52 -0400
Message-ID: <7116FFFA983E9743BB4523E3EA481AA7C86A61@VDHQEXCHANGE.hq.villadirect.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: box reboots when using a non-default memory split and highmem
Thread-Index: AceYjLXYJL+L+oZCTL+G6n1VP3AQHAAAVuuw
From: "Roland Cruse" <roland.cruse@vrs-soft.com>
To: <linux-kernel@vger.kernel.org>
Cc: <daniel@hozac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello

Using a non-default memory split and highmem, booting a 2.6.20.11 kernel
reboots the computer at startup right after its selection using grub. 

//////////////////
/usr/src/linux-2.6.20.11 # grep  VMSPLIT .config
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
//////////////////
/usr/src/linux-2.6.20.11 # grep  HIGHMEM .config
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_HIGHMEM=y
CONFIG_DEBUG_HIGHMEM=y
//////////////////
/usr/src/linux-2.6.20.11 # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 4
cpu MHz         : 2992.829
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc pni monitor ds_cpl est tm2 cid cx16 xtpr lahf_lm
bogomips        : 5989.30
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 4
cpu MHz         : 2992.829
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc pni monitor ds_cpl est tm2 cid cx16 xtpr lahf_lm
bogomips        : 5985.15
clflush size    : 64 
/////////////////
/usr/src/linux-2.6.20.11 # cat /proc/meminfo
MemTotal:      2069304 kB
MemFree:        531576 kB
Buffers:        324764 kB
Cached:         767696 kB
SwapCached:        100 kB
Active:         934448 kB
Inactive:       388716 kB
HighTotal:     1177640 kB
HighFree:       227080 kB
LowTotal:       891664 kB
LowFree:        304496 kB
SwapTotal:     4095992 kB
SwapFree:      4095836 kB
Dirty:             988 kB
Writeback:           0 kB
AnonPages:      220156 kB
Mapped:          31368 kB
Slab:           195044 kB
SReclaimable:   173064 kB
SUnreclaim:      21980 kB
PageTables:       5036 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   5130644 kB
Committed_AS:   888180 kB
VmallocTotal:   116728 kB
VmallocUsed:      4484 kB
VmallocChunk:   111752 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     2048 kB
///////////////////////

Thanks.
--------------------------------------
Roland Cruse

