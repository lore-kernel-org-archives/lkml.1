Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbXFCVPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbXFCVPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXFCVOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:14:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:28409 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXFCVOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z+UqAjlloDnqs6l2QR1fO1qqKxIutogMIm93EdLAzDePNCOv6fYF8F2SPAemS34LMr3iw35t5gyx8/bkkwCuVkSzo1TIaf2cX9L4E1TAeHpKhJbZe1Ubfms9Q80huokLvp57JY5w1/WxT+kgfp1OHm0HWsvs26Y48IzPkk/aUig=
Message-ID: <46632F53.1070103@gmail.com>
Date: Sun, 03 Jun 2007 23:14:59 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ingo Korb <ml@akana.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: stallion driver dmesg notice
References: <46633BC8.3838.43FB8257@ml.akana.de>
In-Reply-To: <46633BC8.3838.43FB8257@ml.akana.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Korb napsal(a):
> Hi!
> 
> The stallion driver in 2.6.21.3 put this little notice in my dmesg:
> 
> === Cut ===
> Stallion Multiport Serial Driver: version 5.6.0
> stallion 0000:00:0b.0: please, report this to LKML: 100b/d001/ffffff
> ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 17
> stallion: probe of 0000:00:0b.0 failed with error -16
> === Cut ===
> 
> The card is a EC8/32-PCI with a single connected panel. It used to work 
> well with 2.4, mostly well with a patched 2.6.8.1, really bad 
> (unstable, lost characters) with 2.6.11(?) and doesn't work at all with 
> 2.6.21.3.
> 
> Should I test it with an EC8/64-PCI? The /32 (ab)uses an IDE controller 
> chip as PCI interface, the /64 uses a PLX PCI9050.
> 
> lspci -vv for the EC8/32:
> === Cut ===
> 00:0b.0 Class ffff: National Semiconductor Corporation 87410 IDE (rev 
> ff) (prog-if ff)
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: I/O ports at d100 [size=8]
> 	Region 1: I/O ports at d200 [size=4]
> 	Region 2: I/O ports at d300 [size=8]
> 	Region 3: I/O ports at d400 [size=4]
> === Cut ===

Thanks. I will look into it,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
