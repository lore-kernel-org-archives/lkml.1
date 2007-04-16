Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXDPSW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXDPSW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbXDPSW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 14:22:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49939 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXDPSW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 14:22:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4623BE2E.2020800@s5r6.in-berlin.de>
Date: Mon, 16 Apr 2007 20:19:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?UTF-8?B?VG9tYXN6IEvFgm9jemtv?= <kloczek@rudy.mif.pg.gda.pl>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Mike Snitzer <snitzer@gmail.com>,
       Neil Brown <neilb@suse.de>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqqwdfzcftfxs2@localhost.localdomain>  <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com> <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr> <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de> <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Kłoczko wrote:
> On Mon, 16 Apr 2007, Stefan Richter wrote:
>> Tomasz Kłoczko wrote:
>>> Current FUSE implemntation can't be
>>> comparable in aspects of speed and probably never will be on using
>>> threads
>>
>> Did you measure this on a few hardwares and workloads?
> 
> Before asking firs you must try look on current ZFS on FUSE discuss
> phorums/docu .. like on:
> http://groups.google.com/group/zfs-fuse/feed/rss_v2_0_msgs.xml
> 
> ZFS on Solaris provides for many workloads better speed than any Linux
> technology on the same hardware but ZFS ond FUSE in current form
> provides lower speed than now avalaible Linux technologies.

There isn't a lot of useful facts in this last sentence.

> Example http://groups.google.com/group/zfs-fuse/msg/5b10c69707a46c07:

That's much more like it...

> "According to bonnie, I see 125 MB/s reads on ext3+RAID5, 65 MB/s on
> ZFS+RAID5 (using Linux's software RAID) and 20 MB/s on ZFS+raidz (using
> the same raw drives).  Writes are also proportionally slower.  The real
> performance hit with ZFS-FUSE was random accesses for lots of small
> files. The bonnie++ results showed something like 75 random seeks for
> ZFS vs 470 for ext3 (..)"

...although the tester doesn't say a lot about the test setup (e.g. no
word on the used hardware).

Another thread in the forum links to
http://www.ntfs-3g.org/performance.html which shows that filesystems
implemented on top of FUSE may actually yield performance in the same
league as classic Linux filesystems.  However that page doesn't say
anything about the test method either, beyond that bonnie++ was used.

> On the same phorun you can find threads with discuss about utilize
> treading under FUSE.

Could you point out what you meant by "not comparable... on using
threads"?  (Who is using which threads for what purposes; what are the
pertaining issues?)  Then I might be able to find those forum posts
which explain why a FUSE fs can never work comparably well "with threads".

>>> (very simmilar case to ALSA and mixing in user space ..
>>
>> Audio is about guaranteed latency, not "speed".
> 
> You meam "guaranteed worser latency" ?

I meant that the central requirement on the design and implementation of
audio subsystems is an (ideally guaranteed) bounded maximum of
latencies; and that's exactly the major point where I heard that there
are problems with ALSA driver components in userspace.  You were talking
about throughput of storage systems, for which latencies of the software
part of the stack do not play such a central role.  Therefore your
comparison appeared off the mark to me.
-- 
Stefan Richter
-=====-=-=== -=-- =----
http://arcgraph.de/sr/
