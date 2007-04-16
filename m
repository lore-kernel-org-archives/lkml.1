Return-Path: <linux-kernel-owner+w=401wt.eu-S1030339AbXDPKXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339AbXDPKXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030325AbXDPKXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:23:40 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:32387 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030339AbXDPKXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:23:39 -0400
Date: Mon, 16 Apr 2007 11:40:07 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
In-Reply-To: <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr>
Message-ID: <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> 
 <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
 <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1378868780-1176716407=:11088"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1378868780-1176716407=:11088
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 14 Apr 2007, Jan Engelhardt wrote:

>
> On Apr 14 2007 10:04, Mike Snitzer wrote:
>>
>> ZFS does have some powerful features but much of it depends on their
>> broken layering of volume management.  Embedding the equivalent of LVM
>> into a filesystem _feels_ quite wrong.
>>
>> [...]
>>
>> Unfortunately in order for Linux to incorporate such a feature I'd
>> imagine a new filesystem would need to be developed with redirect on
>> write at its core.  Can't really see ext4 or any other existing Linux
>> filesystem grafting such a feature into it.  But even though I can't
>> see it; do others?
>
> FUSE-based filesystems. (That said, might wanna try through
> "ZFS-on-fuse" fs).

FUSE implemtation uses too many context switches on each I/O so on the 
same hardware it will never will be so fast as on Linux, BSD and MOX (yes 
ZFS is now avalaible on all this OSes .. and few people says Windows 
implemtation is very close). Current FUSE implemntation can't be 
comparable in aspects of speed and probably never will be on using threads 
(very simmilar case to ALSA and mixing in user space .. in both cases it 
is broken by design). Also ZFS on Solaris uses few other system abilities 
for example it interract with PSH.

So FUSE ZFS is IMO only kind of academic demo implemtation only but never 
will be usefull/ready for production (plain waste of time). If Linux 
licensing will not be relaxed probaly we can forget about ZFS on Linux 
(licensing problems in this case are obly on Linux side .. <ironically>in 
this case ZFS licensing is more oppened than Linux licensing 
</ironically>).

kloczek
PS. IIRC implemting ZFS on FUSE was some kind of workaround for licensing 
issue but FUSE fill uses vfs layer and probaly still thinking about
licensing is actual.
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1378868780-1176716407=:11088--
