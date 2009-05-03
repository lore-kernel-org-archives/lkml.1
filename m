Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZECRMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZECRMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 13:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZECRMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 13:12:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41325 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZECRMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 13:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bC9HJ2aKt5YJyNSH5oLeOV5cWrB1SxcWRQ82UqC6GJkfh8KVPRZYsklp+Og9+sJRCR
         IutOEfRtKtN+QITAA7YyGZsZHNkvw5ct84ttz/Nsi6UlL8NEzKaYF432nDUV/QvxFf2l
         k+7DbiMb9mGDoHWC/2C4+CLx1DnZwGz6gdBAQ=
MIME-Version: 1.0
In-Reply-To: <200905031828.14468.florian@openwrt.org>
References: <38b2ab8a0905030922x722a45f3gf0790b5b90b0f2b3@mail.gmail.com>
	 <200905031828.14468.florian@openwrt.org>
Date: Sun, 3 May 2009 19:12:36 +0200
Message-ID: <38b2ab8a0905031012m5d50b68es22e3c80cfa72fd60@mail.gmail.com>
Subject: Re: v2.6.30-rc4: b44: eth0: BUG! Timeout waiting for bit 00000002 of 
	register 42c to clear.
From: Francis Moreau <francis.moro@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Florian,

On Sun, May 3, 2009 at 6:28 PM, Florian Fainelli <florian@openwrt.org> wrote:
>> I got this since I updated my kernel from 2.6.29 to 2.6.30-rc4.
>>
>> Let me know if you need more information.
>
> Is this seen on a Broadcom 47xx/53xx platform or on a computer with a PCI b44
> card ?
>

$ lspci -vv

06:01.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
        Subsystem: Acer Incorporated [ALI] Device 0090
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>
        Kernel driver in use: b44


Let me know if you need more details.

Thanks
-- 
Francis
