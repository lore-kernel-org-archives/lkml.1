Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZI1AJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZI1AJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 20:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZI1AJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 20:09:30 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:55901 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbZI1AJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 20:09:30 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Wrong Vmalloc numbers in /proc/meminfo
Date: Mon, 28 Sep 2009 02:09:30 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909280209.32457.elendil@planet.nl>
X-OriginalArrivalTime: 28 Sep 2009 00:09:33.0107 (UTC) FILETIME=[F4C8F030:01CA3FCF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.31 (on x86_64) I'm seeing the following in /proc/meminfo.

$ cat /proc/meminfo
MemTotal:        2030968 kB
MemFree:          539408 kB
Buffers:           94984 kB
Cached:           308564 kB
SwapCached:        16048 kB
Active:           652236 kB
Inactive:         428808 kB
Active(anon):     436808 kB
Inactive(anon):   246996 kB
Active(file):     215428 kB
Inactive(file):   181812 kB
Unevictable:        1632 kB
Mlocked:            1632 kB
SwapTotal:       2097144 kB
SwapFree:        1979524 kB
Dirty:                12 kB
Writeback:             0 kB
AnonPages:        671276 kB
Mapped:            57684 kB
Slab:             177692 kB
SReclaimable:     160516 kB
SUnreclaim:        17176 kB
PageTables:        14812 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3112628 kB
Committed_AS:     988780 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      340084 kB
VmallocChunk:   34359387131 kB
DirectMap4k:     2008768 kB
DirectMap2M:       63488 kB

Is it me or are VmallocTotal and VmallocChunk off by a factor 10,000 or so?

Cheers,
FJP
