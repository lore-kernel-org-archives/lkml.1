Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbXHZX7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbXHZX7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 19:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbXHZX7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 19:59:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:7469 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXHZX7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 19:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T9B4WlanLDcCsopMQUWDlDXvYdV7o7E0uH31Fpi82RJKDpOjklzTxF9nroP/uKEttagTp1UmIllenZc2SRIvUhwoEZoqdUmydu2X/sp0WNDDjnqv8wo/bwSwHKXc4U6h+1qNsR6WRQqFXpl4aciOGGeHLKtsyMxNyVQ3tX977MA=
Message-ID: <6bffcb0e0708261659y15b344b7h783a1f5ea43a3899@mail.gmail.com>
Date: Mon, 27 Aug 2007 01:59:11 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Oliver Janscheidt" <oliver.janscheidt@rub.de>
Subject: Re: Problems with disc-performance and libata
Cc: linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <1188158937.6896.4.camel@WG4>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188158937.6896.4.camel@WG4>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

[Adding linux-ide to CC]

On 26/08/07, Oliver Janscheidt <oliver.janscheidt@rub.de> wrote:
> Hi,
>
> I'm using a Lenovo Thinkpad with TOSHIBA MK1234GS HD and MATSHITA
> DVD-RAM UJ-850 on 82801GBM/GHM (ICH7 Family) Serial ATA Storage
> Controller IDE. The Kernel is a 2.6.22.1 from Kernel.org (with 2.6.23-rc1-
> and hdaps-queue-freezing-patch).

Could you try 2.6.23-rc3-git10?

>
> sudo hdparm -t /dev/scd0 gives
>
> Timing buffered disk reads:    2 MB in  4.47 seconds = 457.75 kB/sec

Are you using cracked cd/dvd?


cracked dvd

/sbin/hdparm -t /dev/scd0

/dev/scd0:
 Timing buffered disk reads:    2 MB in  6.36 seconds = 321.78 kB/sec


new shiny dvd

/sbin/hdparm -t /dev/scd0

/dev/scd0:
 Timing buffered disk reads:   14 MB in  3.14 seconds =   4.46 MB/sec

>
> sudo hdparm -t /dev/sda gives
>
> Timing buffered disk reads:  102 MB in  3.04 seconds =  33.51 MB/sec

I've got an old Maxtor HDD (also 5,400 rpm) results are similar.

>
> which is a quite poor performance and makes any streaming impossible.
> Obviously UDMA is working correctly as dmesg | grep UDMA says:
>
> [   43.636590] ata1: SATA max UDMA/133 cmd 0xffffc20004612500 ctl
> 0x0000000000000000 bmdma 0x0000000000000000 irq 314
> [   43.636595] ata2: SATA max UDMA/133 cmd 0xffffc20004612580 ctl
> 0x0000000000000000 bmdma 0x0000000000000000 irq 314
> [   43.636599] ata3: SATA max UDMA/133 cmd 0xffffc20004612600 ctl
> 0x0000000000000000 bmdma 0x0000000000000000 irq 314
> [   43.636603] ata4: SATA max UDMA/133 cmd 0xffffc20004612680 ctl
> 0x0000000000000000 bmdma 0x0000000000000000 irq 314
> [   44.177980] ata1.00: ATA-7: TOSHIBA MK1234GSX, AH002E, max UDMA/100
> [   44.179192] ata1.00: configured for UDMA/100
> [   44.326918] ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl
> 0x00000000000103f6 bmdma 0x0000000000011880 irq 14
> [   44.326922] ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl
> 0x0000000000010376 bmdma 0x0000000000011888 irq 15
> [   44.571970] ata5.00: ATAPI: MATSHITADVD-RAM UJ-850, RB01, max UDMA/33
> [   44.738552] ata5.00: configured for UDMA/33
> [    0.610332] ata5.00: configured for UDMA/33
> [    0.750296] ata1.00: configured for UDMA/100
>
> Is there any solution for that problem or at least a workaround?
>
> I also tried to recompile the kernel as recommended in the official
> libata-faq ( http://linux-ata.org/faq.html ) but the system stuck when
> booting the root-partition. Booting with combined_mode=libata or
> combined_mode=ide didn't affect the performance, too.
>
> Thanks in advance,
>
> Oli
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
