Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYDLQBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYDLQBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYDLQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:01:41 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:56866 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYDLQBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:01:40 -0400
Date: Sat, 12 Apr 2008 18:01:38 +0200
Message-Id: <236468686@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Luis Sousa <ls.luis_sousa@yahoo.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24 [POSSIBLE SOLUTION]
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX187Ls4zRT04jLV3KYBP99DpNHIZD3ks7SlOZOhnH6N6b9bVb
 M8BrX4PXy6E/BKgH19jzYGLI/+QPjY2afzLkHyqPRDrbAF22AA=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi luis, 

glad that it worked - but let us better call this a possible workaround, not a solution.

mind that you loose lots of performance with this, because all i/o is handled by the cpu now.

> If everything goes well, I'll reduce the command line
> in order to narrow the problem further down.

yes, please!

regards
roland





> -----Ursprüngliche Nachricht-----
> Von: "Luis Sousa" <ls.luis_sousa@yahoo.com.br>
> Gesendet: 12.04.08 17:34:39
> An: devzero@web.de
> CC: linux-kernel@vger.kernel.org
> Betreff: Re: sata io freeze, 2.6.18 and also 2.6.24 [POSSIBLE SOLUTION]


> 
> Hello all,
> 
> Thanks to valuable help from roland, I was able to
> boot with the following options:
> 
> ``nosmp ide=nodma libata.dma=0''
> 
> after what I ran an agressive stability test for a
> while, with no problem whatsoever. Maybe it's too
> soon to say, but I have a good feeling this time. It
> seems roland figured it out.
> 
> If everything goes well, I'll reduce the command line
> in order to narrow the problem further down.
> 
> (and indeed, this is a hyper-threading single core CPU)
> 
> Sincerely,
> --
> Luis Sousa
> 
> --- devzero@web.de escreveu:
> 
> > did you try UP-kernel or tried booting with "nosmp" and does that make any difference ?
> > 
> > >This is a 2-processor CPU:
> > ># cat /proc/cpuinfo 
> > >processor       : 0
> > >vendor_id       : GenuineIntel
> > >cpu family      : 15
> > >model           : 4
> > >model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> > 
> > most likely this just "appears" as 2-way processor , but i´m quite sure this is just a
> > single-core CPU, but with HyperThreading enabled.
> > 
> > 
> > regards
> > roland
> > 
> > 
> > 
> > List:       linux-kernel
> > Subject:    sata io freeze, 2.6.18 and also 2.6.24
> > From:       Luis Sousa <ls.luis_sousa () yahoo ! com ! br>
> > Date:       2008-03-28 22:24:48
> > Message-ID: 739784.81690.qm () web46009 ! mail ! sp1 ! yahoo ! com
> > [Download message RAW]
> > 
> > Hello,
> > 
> > I've been having consistent hard system freezes for a
> > long time, every 2 days or so, and finally decided to
> > move to the most recent stable kernel. Unfortunatelly
> > that didn't fix it. The freezes seem to be io-related;
> > they started since I moved my drive to sata. They seem
> > to happen mostly when there's an io-intensive operation,
> > like extracting a big archive; a reboot is needed.
> > 
> > Nothing ever shows up in the logs.
> > 
> > I'm using the following drive:
> > 
> > ATA device, with non-removable media
> >         Model Number:       MAXTOR STM3160215AS                     
> >         Serial Number:      6RA2TMJ4
> >         Firmware Revision:  3.AAD   
> > 
> > Linux localhost 2.6.24.4 #4 SMP Fri Mar 28 14:51:50 BRT 2008 i686 GNU/Linux
> > 
> > This is a 2-processor CPU:
> > 
> > # cat /proc/cpuinfo 
> > processor       : 0
> > vendor_id       : GenuineIntel
> > cpu family      : 15
> > model           : 4
> > model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> > stepping        : 9
> > cpu MHz         : 3013.697
> > cache size      : 1024 KB
> > 
> > (same goes for processor : 1)
> > 
> > Sincerely,
> > --
> > Luis Sousa
> > _____________________________________________________________________
> > Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
> > http://smartsurfer.web.de/?mc=100071&distributionid=000000000066
> > 
> > 
> 
> 
> 
>       Abra sua conta no Yahoo! Mail, o único sem limite de espaço para armazenamento!
> http://br.mail.yahoo.com/
> 
> 


_________________________________________________________________________
Mit der Gruppen-SMS von WEB.DE FreeMail können Sie eine SMS an alle 
Freunde gleichzeitig schicken: http://freemail.web.de/features/?mc=021179



