Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZEPDM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZEPDM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 23:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZEPDMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 23:12:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:7572 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbZEPDMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 23:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qfM84YcTqOFmUSmntPOT6wxLm+qr2EwOcOcWPqk88oJwmHTX+c2qA6o94P7DTd0k87
         0XwSKlrIh3JIXVxI8gRovPhoTjizuYQsimTlkr3IM5VjJWnUb1eTrqga+1O+iQmEb+WG
         1WlbRnSJKv7te1xGq9ginpOWSofr1pSUYbuiw=
MIME-Version: 1.0
In-Reply-To: <5bdc1c8b0905151947j326d31d9k5c7b1074af2b0bf0@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <5bdc1c8b0905151012x51c19b5cv639cadab1cee3849@mail.gmail.com>
	 <93655eb70905151024o634f8432j6c3db85df1f6ddfc@mail.gmail.com>
	 <5bdc1c8b0905151120p5aa58318t1765544fbbb695b2@mail.gmail.com>
	 <93655eb70905151938y558bf86flcfb7c6b6b2c171c6@mail.gmail.com>
	 <5bdc1c8b0905151947j326d31d9k5c7b1074af2b0bf0@mail.gmail.com>
Date: Sat, 16 May 2009 08:42:47 +0530
Message-ID: <93655eb70905152012j2a40d2e0ta413a5e9dee34d46@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Mark Knecht <markknecht@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I googled on "82801GBM/GHM slow" and found a lot to read.

will read through that ,...

> Is DMA for this drive enabled? It seems that some others didn't have
> it enabled by default, or maybe at all. I didn't real the threads very
> far.

the udma5 mode seems to be enabled , though I can't really make any
sense out of it:

hdparm -i /dev/sda

/dev/sda:

 Model=TOSHIBA MK1234GSX                       , FwRev=AH001H  ,
SerialNo=           372HFDVGS
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=0kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=234441648
 IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  sdma0 sdma1 sdma2 mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
 AdvancedPM=yes: unknown setting WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-3,4,5,6,7

 * signifies the current active mode

> hdparm -d1 /dev/sda

got the following error when I tried setting the mode as above, I
think along with -d1 we need to give some "X" argument( or so reads
the man page)..

 hdparm -d1 /dev/sda

/dev/sda:
 setting using_dma to 1 (on)
 HDIO_SET_DMA failed: Inappropriate ioctl for device
 HDIO_GET_DMA failed: Inappropriate ioctl for device

> Clearly, since you see the same thing in a console with X never having
> been started says it's not a GUI issue.

yes I suppose, but any idea how I figure out what exactly is causing
the IOWAIT, .. and if there are any patches, let me know, I can test
them .

Cheers
Satish
-- 
http://satish.playdrupal.com
