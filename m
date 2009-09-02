Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZIBTW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZIBTW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZIBTW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:22:29 -0400
Received: from lo.gmane.org ([80.91.229.12]:38218 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbZIBTW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:22:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: LowFree pattern
Date: Wed, 02 Sep 2009 15:22:11 -0400
Message-ID: <h7mgl3$v6$1@ger.gmane.org>
References: <fb7befa20909020932k74fa9e37x1eeabdb494835bb9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-72-92-176-172.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 pango-text SeaMonkey/1.1.16
In-Reply-To: <fb7befa20909020932k74fa9e37x1eeabdb494835bb9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adayadil Thomas wrote:
> Greetings.
> 
> I am running a centos linux with 2.6.20 version kernel. The system has
> 1G of RAM.
> 
> As time goes by the LowFree becomes really low. Right now it shows
> 137M .. but it goes as low as 8M or so
> 
> The command -
> echo 3 > /proc/sys/vm/drop_caches
> brings back the LowFree to way up high.
> 
> The question I have is whether the system by itself release the cache
> (drop cache) automatically
> to maintain a reasonable LowFree?
> Is this configurable?
> 
You can change the parameters in /rpoc/sys/vm if you wish, but what makes you 
think this is needed? Cache is dropped as memory is needed, and drop_cache in 
general is a good way to slow the system.

> Any information or help is much appreciated.
> 
What problem did you see that you traced to LowFree?

> 
> cat /proc/meminfo
> MemTotal:      1034788 kB
> MemFree:        138240 kB
> Buffers:         99260 kB
> Cached:         177776 kB
> SwapCached:      51740 kB
> Active:         605172 kB
> Inactive:       113572 kB
> HighTotal:      130720 kB
> HighFree:          252 kB
> LowTotal:       904068 kB
> LowFree:        137988 kB
> SwapTotal:     1048568 kB
> SwapFree:       976332 kB
> Dirty:             380 kB
> Writeback:           0 kB
> AnonPages:      441348 kB
> Mapped:          15540 kB
> Slab:           146088 kB
> SReclaimable:   104288 kB
> SUnreclaim:      41800 kB
> PageTables:       1596 kB
> NFS_Unstable:        0 kB
> Bounce:              0 kB
> CommitLimit:   1565960 kB
> Committed_AS:   590576 kB
> VmallocTotal:   114680 kB
> VmallocUsed:     15052 kB
> VmallocChunk:    99348 kB


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

