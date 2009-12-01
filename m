Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZLAQEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZLAQEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZLAQEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:04:04 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:52315 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZLAQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:03:59 -0500
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 11:03:58 EST
Message-ID: <4B1537CA.7020107@xenontk.org>
Date: Tue, 01 Dec 2009 21:05:38 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1.4pre) Gecko/20091014 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jonathan Miles <jon@cybus.co.uk>, cl@linux-foundation.org,
       penberg@cs.helsinki.fi
Subject: Re: OOM kernel behaviour
References: <4B1402FC.80307@cybus.co.uk>
In-Reply-To: <4B1402FC.80307@cybus.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 11:08 PM, Jonathan Miles wrote:
> Hi all,
> 
> I'm not on the list, so please cc me.
> 
> I'm trying to figure out why the OOM killer is being called on my
> workstation even though the last time there was nearly 1.2GB of memory
> used by the page cache, which IMHO could have been used instead.

<snip>

Hi,

I have started seeing the same problem too. I am running a 64-bit custom
compiled 2.6.31 kernel (Fedora 11) on a Dell Inspiron laptop. The funny
thing is my laptop has been running fine ever since 2.6.31 released, but
this problem has started only recently, about a week back or so. I
update Fedora daily, so I figure one of the updates could have triggered
this behaviour.

For instance, here is the mem info on my laptop as I type this out:

MemTotal:        2020588 kB
MemFree:           17680 kB
Buffers:            3568 kB
Cached:          1202744 kB
SwapCached:        35748 kB
Active:          1364408 kB
Inactive:         480464 kB
Active(anon):    1315120 kB
Inactive(anon):   441480 kB
Active(file):      49288 kB
Inactive(file):    38984 kB
Unevictable:          40 kB
Mlocked:              40 kB
SwapTotal:       2048248 kB
SwapFree:         603276 kB
Dirty:                72 kB
Writeback:             0 kB
AnonPages:        606484 kB
Mapped:            75716 kB
Slab:              65104 kB
SReclaimable:      20036 kB
SUnreclaim:        45068 kB
PageTables:        22960 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3058540 kB
Committed_AS:    6557484 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      357788 kB
VmallocChunk:   34359303907 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8956 kB
DirectMap2M:     2050048 kB

If I start something like Firefox now, the OOM killer is invoked and the
machine is unusable until it completes. Sometimes the killer is invoked
multiple times and the only way to make the PC usable again is
to Ctrl-Alt-Bksp out of X. If RAM is low, why isn't the cache being
reclaimed?

The issue is sporadic but almost guaranteed if I leave the machine on
for more than 18 hours. I initially thought some process was leaking
memory but that seems unlikely.

I can provide more info and do some testing (config etc.) if required.

Regards,
David.
