Return-Path: <linux-kernel-owner+w=401wt.eu-S1161647AbXBOXCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161647AbXBOXCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161649AbXBOXCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:02:03 -0500
Received: from mail.um.es ([155.54.212.109]:45733 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161647AbXBOXCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:02:01 -0500
Date: Thu, 15 Feb 2007 23:59:14 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070215200922.GB24643@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
 <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-36369700-1171580354=:19998"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-36369700-1171580354=:19998
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Jörn,

On Thu, 15 Feb 2007, [utf-8] Jörn Engel wrote:

> On Thu, 15 February 2007 19:38:14 +0100, Juan Piernas Canovas wrote:
>>
>> The patch for 2.6.11 is not still stable enough to be released. Be patient
>> ;-)
>
> While I don't want to discourage you, this is about the point in
> development where most log structured filesystems stopped.  Doing a
> little web research, you will notice those todo-lists with "cleaner"
> being the top item for...years!
>
> Getting that one to work robustly is _very_ hard work and just today
> I've noticed that mine was not as robust as I would have liked to think.
> Also, you may note that by updating to newer kernels, the VM writeout
> policies can change and impact your cleaner.  To an extent even that you
> had a rock-solid filesystem with 2.6.18 and thing crumble between your
> fingers in 2.6.19 or later.
>
> If the latter happens, most likely the VM is not to blame, it just
> proved that your cleaner is still getting some corner-cases wrong and
> needs more work.  There goes another week of debugging. :(
>
> Jörn
>
Actually, the version of DualFS for Linux 2.4.19 implements a cleaner. In 
our case, the cleaner is not really a problem because there is not too 
much to clean (the meta-data device only contains meta-data blocks which 
are 5-6% of the file system blocks; you do not have to move data blocks).

Anyway, thank you for warning me ;-)

Regards,

 	Juan.

-- 
D. Juan Piernas Cánovas
Departamento de Ingeniería y Tecnología de Computadores
Facultad de Informática. Universidad de Murcia
Campus de Espinardo - 30080 Murcia (SPAIN)
Tel.: +34968367657    Fax: +34968364151
email: piernas@ditec.um.es
PGP public key:
http://pgp.rediris.es:11371/pks/lookup?search=piernas%40ditec.um.es&op=index

*** Por favor, envíeme sus documentos en formato texto, HTML, PDF o PostScript :-) ***
--916140492-36369700-1171580354=:19998--
