Return-Path: <linux-kernel-owner+w=401wt.eu-S1030653AbXDPOUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030653AbXDPOUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030654AbXDPOUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:20:44 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:35234 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030653AbXDPOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:20:43 -0400
Date: Mon, 16 Apr 2007 16:20:41 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Mike Snitzer <snitzer@gmail.com>,
       Neil Brown <neilb@suse.de>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
In-Reply-To: <46238204.9060907@s5r6.in-berlin.de>
Message-ID: <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> 
 <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
 <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr>
 <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1435485136-1176733241=:11088"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1435485136-1176733241=:11088
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 16 Apr 2007, Stefan Richter wrote:

> Tomasz K³oczko wrote:
>> Current FUSE implemntation can't be
>> comparable in aspects of speed and probably never will be on using threads
>
> Did you measure this on a few hardwares and workloads?

Before asking firs you must try look on current ZFS on FUSE 
discuss phorums/docu .. like on: 
http://groups.google.com/group/zfs-fuse/feed/rss_v2_0_msgs.xml

ZFS on Solaris provides for many workloads better speed than any Linux 
technology on the same hardware but ZFS ond FUSE in current form provides 
lower speed than now avalaible Linux technologies.

Example http://groups.google.com/group/zfs-fuse/msg/5b10c69707a46c07:

"According to bonnie, I see 125 MB/s reads on ext3+RAID5, 65 MB/s on 
ZFS+RAID5 (using Linux's software RAID) and 20 MB/s on ZFS+raidz (using 
the same raw drives).  Writes are also proportionally slower.  The real 
performance hit with ZFS-FUSE was random accesses for lots of small files. 
The bonnie++ results showed something like 75 random seeks for ZFS vs 470 
for ext3 (..)"

On the same phorun you can find threads with discuss about utilize 
treading under FUSE.

>> (very simmilar case to ALSA and mixing in user space ..
>
> Audio is about guaranteed latency, not "speed".

You meam "guaranteed worser latency" ? excelent 8-)

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1435485136-1176733241=:11088--
