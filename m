Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYLOJxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYLOJxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 04:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYLOJw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 04:52:58 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:51543 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbYLOJw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 04:52:57 -0500
Date: Mon, 15 Dec 2008 10:53:11 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081215095311.GB4422@ics.muni.cz>
References: <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost> <20081215110231.00DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081215110231.00DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 15 Dec 2008 10:52:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Dec 15, 2008 at 11:05:24AM +0900, KOSAKI Motohiro wrote:
> I also don't reproduce your problem.
> Could you get output of "cat /proc/meminfo", not only free command?

attached meminfo and vmstat after dropping caches.

-- 
Luká¹ Hejtmánek

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename=meminfo

MemTotal:        2016688 kB
MemFree:         1528748 kB
Buffers:             424 kB
Cached:           140060 kB
SwapCached:            0 kB
Active:           353252 kB
Inactive:          47332 kB
Active(anon):     329884 kB
Inactive(anon):        4 kB
Active(file):      23368 kB
Inactive(file):    47328 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       1542232 kB
SwapFree:        1542232 kB
Dirty:                64 kB
Writeback:             0 kB
AnonPages:        260100 kB
Mapped:            85036 kB
Slab:              24708 kB
SReclaimable:       8532 kB
SUnreclaim:        16176 kB
PageTables:        10324 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2550576 kB
Committed_AS:     576152 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      332160 kB
VmallocChunk:   34359404539 kB
DirectMap4k:       45760 kB
DirectMap2M:     2009088 kB

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename=vmstat

nr_free_pages 382094
nr_inactive_anon 1
nr_active_anon 82469
nr_inactive_file 11835
nr_active_file 5905
nr_unevictable 0
nr_mlock 0
nr_anon_pages 65025
nr_mapped 21228
nr_file_pages 35187
nr_dirty 17
nr_writeback 0
nr_slab_reclaimable 2133
nr_slab_unreclaimable 4043
nr_page_table_pages 2581
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
nr_writeback_temp 0
pgpgin 271982
pgpgout 10689
pswpin 0
pswpout 0
pgalloc_dma 120
pgalloc_dma32 593606
pgalloc_normal 0
pgalloc_movable 0
pgfree 976064
pgactivate 13699
pgdeactivate 0
pgfault 947747
pgmajfault 1688
pgrefill_dma 0
pgrefill_dma32 0
pgrefill_normal 0
pgrefill_movable 0
pgsteal_dma 0
pgsteal_dma32 0
pgsteal_normal 0
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_dma32 0
pgscan_kswapd_normal 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 0
pgscan_direct_normal 0
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 30080
kswapd_steal 0
kswapd_inodesteal 0
pageoutrun 0
allocstall 0
pgrotated 0
unevictable_pgs_culled 1
unevictable_pgs_scanned 0
unevictable_pgs_rescued 9
unevictable_pgs_mlocked 9
unevictable_pgs_munlocked 9
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0

--9amGYk9869ThD9tj--
