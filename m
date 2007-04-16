Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXDPOB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXDPOB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030628AbXDPOB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:01:27 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:30185 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030621AbXDPOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:01:26 -0400
Date: Mon, 16 Apr 2007 16:01:23 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Mike Snitzer <snitzer@gmail.com>
cc: Neil Brown <neilb@suse.de>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
In-Reply-To: <170fa0d20704160507w4af4cb92ua259a55789f95c3e@mail.gmail.com>
Message-ID: <Pine.BSO.4.63.0704161419260.11088@rudy.mif.pg.gda.pl>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> 
 <17952.5537.364603.419364@notabene.brown>  <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
  <Pine.BSO.4.63.0704161140460.11088@rudy.mif.pg.gda.pl>
 <170fa0d20704160507w4af4cb92ua259a55789f95c3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1098872399-1176732083=:11088"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1098872399-1176732083=:11088
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 16 Apr 2007, Mike Snitzer wrote:
[..]
> The ZFS volume management piece could've easily been abstracted to be
> outside of the actual filesystem.

Sorry .. but can you poof this by show one example of this kind of 
problems ?

> In fact its more natural to maintain that separation.

Sorry but cause of developing ZFS was not braking classic/"natural" FS 
abstraction but try to solve things like limited I/O bandwich and 
statatistical number of errors on storing portion informations (it 
~constant but capacity of used storage divices grows) now avalaible 
storage devices and simplify managing hundrets or thousands phisical 
devices. From this point of view it is state of art.

> It allows people to have choices about how they manage the underlying 
> block layer rather than imposing one specialized solution.  Look at the 
> various technologies in Linux (LVM2, MD, Linux Multipath) to understand 
> the flexibility Linux provides for managing storage.

Except ext4 all this all this technologies not solves some problems which 
are plugged by ZFS. Also adding checksuming to ext3 (aka ext4) it is not 
all what profides ZFS way ..

> Not to mention the availability of commercial solutions from the various 
> storage vendors.

It is not matter comercial/non-commercial .. forget about this argument 
(don't practice this kind of FUDing).

ZFS was implemnted and is useable .. very useable like many commersial 
technologiess (do you remenber form where come NFS to Linux ?)
It is so useable it case many people are now ready for switch from Linux 
to Solaris.
Few days ago I'm swich two backup servers with few TB storage from Linux 
to Solaris .. only because client want use ZFS .. because ZFS is EXCELENT 
for this kind tasks (only because it allow save many thousands of 
<put_your_currency_name> because it allow better utilize the same storage) 
and trust me .. cases like this will be more .. much more and changing 
licensing Linux code will be MUCH more easier than reinventing wheel (wich 
will be reimplemnting ZFS under GPL).

Problem is not on technical area but on licensing and it is plain Linux 
word problem because neccessary in this case changes on CDDL side will 
make this code less oppended than now .. so you can (probably ?) forget 
about GPLing ZFS code (and ZFS it is not all what will good to have from 
Sol in Linux).
IMO current Linux licensing less is importand than bringing in possible 
simpler way things like ZFS to Linux. So best/simpler way will be start 
change Linux licensing for save all GPL goodies and allow interract with 
code on license like CDDL.
Licensing is for allow keep in best possible form Linux. If it can't do 
this in best possible way it must be change (must evolve .. like 
many othes things around).

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1098872399-1176732083=:11088--
