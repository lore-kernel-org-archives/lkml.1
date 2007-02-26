Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbXBZDsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbXBZDsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 22:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933752AbXBZDsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 22:48:53 -0500
Received: from mail.um.es ([155.54.212.109]:35280 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751AbXBZDsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 22:48:52 -0500
Date: Mon, 26 Feb 2007 04:48:51 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070225120138.GA19047@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0702260442030.25255@ditec.inf.um.es>
References: <20070220003059.GJ7813@lazybastard.org>
 <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es> <20070221123753.GA464@lazybastard.org>
 <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es> <20070221192523.GG3219@lazybastard.org>
 <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es> <20070222162547.GB7149@lazybastard.org>
 <Pine.LNX.4.61.0702222033460.19296@ditec.inf.um.es> <20070223132645.GB11653@lazybastard.org>
 <Pine.LNX.4.61.0702250255530.18915@ditec.inf.um.es> <20070225120138.GA19047@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-299309155-1172461731=:25255"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-299309155-1172461731=:25255
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 25 Feb 2007, [utf-8] Jörn Engel wrote:

> On Sun, 25 February 2007 03:41:40 +0100, Juan Piernas Canovas wrote:
>>
>> Well, our experimental results say another thing. As I have said, the
>> greatest part of the files are written at once, so their meta-data blocks
>> are together on disk. This allows DualFS to implement an explicit
>> prefetching of meta-data blocks which is quite effective, specially when
>> there are several processes reading from disk at the same time.
>>
>> On the other hand, DualFS also implements an on-line meta-data relocation
>> mechanism which can help to improve meta-data prefetching, and garbage
>> collection.
>>
>> Obviously, there can be some slow-growing files that can produce some
>> garbage, but they do not hurt the overall performance of the file system.
>
> Well, my concerns about the design have gone.  There remain some
> concerns about the source code and I hope they will disappear just as
> fast. :)
>
This is a bit more complicated ;)

> Obviously, a patch against 2.4.x is fairly useless.  Iirc, you claimed
> somewhere to have a patch against 2.6.11, but I was unable to find that.
> Porting 2.6.11 to 2.6.20 should be simple enough.

I'm working on a public patch of DualFS for Linux 2.6.x. It's a matter of 
time.

>
> Then there is some assembly code inside the patch that you seem to have
> copied from some other project.  I would be surprised if that is really
> required.  If you can replace it with C code, please do.
>
> If the assembly actually is a performance gain (and I consider it your
> duty to prove that), you can have a two-patch series with the first
> introducing DualFS and the second adding the assembly as a config option
> for one architecture.
>
No problem. I will see if the assembly code can be replaced with bare C.

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
--916140492-299309155-1172461731=:25255--
