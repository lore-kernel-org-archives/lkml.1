Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYFXFRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYFXFRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYFXFRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:17:07 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3213 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYFXFRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:17:06 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2008 01:17:06 EDT
Mime-Version: 1.0 (Apple Message framework v624)
Content-Transfer-Encoding: 7bit
Message-Id: <2c84b89ef40f92173a026b8d95e889ad@xs4all.nl>
Content-Type: text/plain; charset=US-ASCII; format=flowed
To: linux-kernel@vger.kernel.org
From: Joris van Rantwijk <jorispubl@xs4all.nl>
Subject: Physical memory disappeared from /proc/meminfo
Date: Tue, 24 Jun 2008 07:09:00 +0200
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My system got into a situation where a lot of physical memory is
in use. I want to know where this memory is being used, but it
seems to have become untraceable somehow.

My total physical memory is 1 GB.
Adding up all VSZ numbers from "ps auxw" gets me to about 75 MB,
so I should have a lot of free memory but I don't see it.

My kernel is Linux 2.6.25.4 for x86_64 with a 32-bit userland.
I disabled swap to make it easier to investigate this issue.

One problem is that I can't really make sense of /proc/meminfo.
As far as I understand the numbers, I find that about 640 MB is
unaccounted for.

For example I would expect that
MemTotal = MemFree + Buffers + Cached + AnonPages + Mapped + Slab.

Is that a valid assumption?
Why does it not hold for my machine?
Is this a bug in the memory statistics?
What part of the system is using all this untraceable memory?

/proc/meminfo:
MemTotal:     996320 kB
MemFree:       67708 kB
Buffers:       17716 kB
Cached:        62412 kB
SwapCached:        0 kB
Active:        27320 kB
Inactive:      58720 kB
SwapTotal:         0 kB
SwapFree:          0 kB
Dirty:            12 kB
Writeback:         0 kB
AnonPages:      5932 kB
Mapped:         3916 kB
Slab:         193560 kB
SReclaimable:  26076 kB
SUnreclaim:   167484 kB
PageTables:      464 kB
NFS_Unstable:      0 kB
Bounce:            0 kB
CommitLimit:  498160 kB
Comitted_AS:   15536 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     600 kB
VmallocChunk: 34359736326 kB

Please help.

Joris.

