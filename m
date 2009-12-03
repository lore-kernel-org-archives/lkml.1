Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZLCVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZLCVQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZLCVQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:16:16 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:37665 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbZLCVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:16:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VAI4p8MROMxop6xrzwTg84ooQ03W60lu1njwvzG5Kc2iHaYWz4Xpw3Bqi4XWIhAggC
         9jY8NBm/6PidTzbNcFu/0EuMZ4XRJ7/je0xI/SIT4VAmWueWxt7TRRnNZ5imcrotbR7h
         2Yrd319nIs4l/XGNhkztTsf2hs5Rmont2vin0=
Message-ID: <4B182A9F.5090708@garzik.org>
Date: Thu, 03 Dec 2009 16:16:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912031339.14440.bzolnier@gmail.com> <4B17FB37.2030501@garzik.org> <200912032045.48728.bzolnier@gmail.com>
In-Reply-To: <200912032045.48728.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan,

Can you sanity check me on these?

> Bartlomiej Zolnierkiewicz (28):
>        ide-pci-generic: build fix

ACK but skipped -- already applied myself

>        ata_piix: fix MWDMA handling on PIIX3

applied

>        pata_efar: fix wrong PIO timings being programmed

applied

>        pata_efar: fix wrong MWDMA timings being programmed

applied

>        pata_efar: MWDMA0 is unsupported

skipped, pending discussion (just sent email)

>        pata_cmd640: document known issues

rejected, for reasons already explained

>        pata_cs5520: remove dead VDMA support

applied

>        pata_cypress: document known issues

rejected, for reasons already explained

>        pata_hpt3x2n: fix overclocked MWDMA0 timing

skipped, pending discussion (just sent email)

>        pata_hpt3x3: Power Management fix

applied, on a hope and a prayer (did not see this posted to mailing 
list?).  It looks correct to me.

>        pata_it8213: fix UDMA handling

applied

>        pata_it8213: fix wrong PIO timings being programmed

applied

>        pata_it8213: fix PIO2 underclocking

applied

>        pata_it8213: fix wrong MWDMA timings being programmed

applied

>        pata_it8213: fix it8213_pre_reset() documentation

applied

>        pata_it8213: MWDMA0 is unsupported

skipped, pending discussion (just sent email)

>        pata_legacy: fix QDI6580DP support

applied

>        pata_legacy: fix access to control register for QDI6580

applied

>        pata_legacy: add pointers to QDI65x0 documentation

applied.  I did not think the file path issue raised was important 
enough to warrant patch rejection.

>        pata_marvell: fix marvell_pre_reset() documentation

applied

>        pata_ns87415: Power Management fix

applied

>        pata_oldpiix: MWDMA0 is unsupported

skipped -- Alan, Sergey, comments?

>        pata_pdc202xx_old: document known issues

rejected, for reasons already explained

>        pata_radisys: fix UDMA handling

applied

>        pata_rdc: MWDMA0 is unsupported

skipped -- Alan, Sergey, comments?

>        pata_rz1000: Power Management fix

applied

>        pata_sis: Power Management fix

applied

>        pata_via: clear UDMA transfer mode bit for PIO and MWDMA

applied -- even though Alan's comment was correct.  It is standard 
kernel practice to place cosmetic changes into their own patches, 
because it is standard kernel practice to break up logically distinct 
changes.

