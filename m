Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbYDLPeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbYDLPeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYDLPef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:34:35 -0400
Received: from n60.bullet.mail.sp1.yahoo.com ([98.136.44.40]:38304 "HELO
	n60.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753017AbYDLPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:34:34 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 418991.26939.bm@omp503.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=l7I77+WmnrqYxoF31klRZZINwwHmybbRweUo/dfrXbJ5wDynVPlfvQmbmMowHHU5gfHh3RKUHCbzEeDlJ4vRIm0TavwLC2P3TJmgHE2vwSq6REbkkphBf/2+KLllP1O6fOHJitIh4qD1R5q4vaO/yFnvfejrpP2CMyfhG9JXkJ4=;
X-YMail-OSG: faLVFDcVM1mZpw1Sun.KtSEnoyYkDKwf0nfJhvViPc9bU80qzEipGp5cG86lEqf4JCzdxW2WTnErZeh4qnXa1N2uokT43zqwYfSJ
Date: Sat, 12 Apr 2008 12:34:34 -0300 (ART)
From: Luis Sousa <ls.luis_sousa@yahoo.com.br>
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24 [POSSIBLE SOLUTION]
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <236054348@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <323569.14380.qm@web46010.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Thanks to valuable help from roland, I was able to
boot with the following options:

``nosmp ide=nodma libata.dma=0''

after what I ran an agressive stability test for a
while, with no problem whatsoever. Maybe it's too
soon to say, but I have a good feeling this time. It
seems roland figured it out.

If everything goes well, I'll reduce the command line
in order to narrow the problem further down.

(and indeed, this is a hyper-threading single core CPU)

Sincerely,
--
Luis Sousa

--- devzero@web.de escreveu:

> did you try UP-kernel or tried booting with "nosmp" and does that make any difference ?
> 
> >This is a 2-processor CPU:
> ># cat /proc/cpuinfo 
> >processor       : 0
> >vendor_id       : GenuineIntel
> >cpu family      : 15
> >model           : 4
> >model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> 
> most likely this just "appears" as 2-way processor , but i´m quite sure this is just a
> single-core CPU, but with HyperThreading enabled.
> 
> 
> regards
> roland
> 
> 
> 
> List:       linux-kernel
> Subject:    sata io freeze, 2.6.18 and also 2.6.24
> From:       Luis Sousa <ls.luis_sousa () yahoo ! com ! br>
> Date:       2008-03-28 22:24:48
> Message-ID: 739784.81690.qm () web46009 ! mail ! sp1 ! yahoo ! com
> [Download message RAW]
> 
> Hello,
> 
> I've been having consistent hard system freezes for a
> long time, every 2 days or so, and finally decided to
> move to the most recent stable kernel. Unfortunatelly
> that didn't fix it. The freezes seem to be io-related;
> they started since I moved my drive to sata. They seem
> to happen mostly when there's an io-intensive operation,
> like extracting a big archive; a reboot is needed.
> 
> Nothing ever shows up in the logs.
> 
> I'm using the following drive:
> 
> ATA device, with non-removable media
>         Model Number:       MAXTOR STM3160215AS                     
>         Serial Number:      6RA2TMJ4
>         Firmware Revision:  3.AAD   
> 
> Linux localhost 2.6.24.4 #4 SMP Fri Mar 28 14:51:50 BRT 2008 i686 GNU/Linux
> 
> This is a 2-processor CPU:
> 
> # cat /proc/cpuinfo 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 4
> model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 9
> cpu MHz         : 3013.697
> cache size      : 1024 KB
> 
> (same goes for processor : 1)
> 
> Sincerely,
> --
> Luis Sousa
> _____________________________________________________________________
> Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
> http://smartsurfer.web.de/?mc=100071&distributionid=000000000066
> 
> 



      Abra sua conta no Yahoo! Mail, o único sem limite de espaço para armazenamento!
http://br.mail.yahoo.com/

