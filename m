Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbXL3Rce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbXL3Rce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbXL3Rbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:31:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:7069 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbXL3Rbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:31:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=l8kRI2qtGSBXCzuzy/got4EsM5OW+1W3fb98zGXMj3T1zltfscMcTc+S+Nx++NTaycgwvyyXzg6hGsGCK3dpNG8LzFqGtEYBLKM2GaU3T+1+9ME+WpnHpeM2hSq9Mi97jc/MVUNM1g3L/j8aTVhZmwRNsht23G2XcMqJvIUfMNk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 1/9] piix: remove stale comments
Date: Sun, 30 Dec 2007 18:09:08 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain> <20071227191200.1357.71766.sendpatchset@localhost.localdomain> <4774E5C6.90506@ru.mvista.com>
In-Reply-To: <4774E5C6.90506@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712301809.08385.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> > Index: b/drivers/ide/pci/piix.c
> > ===================================================================
> > --- a/drivers/ide/pci/piix.c
> > +++ b/drivers/ide/pci/piix.c
> > @@ -8,53 +8,8 @@
> >   *
> >   *  May be copied or modified under the terms of the GNU General Public License
> >   *
> > - *  PIO mode setting function for Intel chipsets.
> > - *  For use instead of BIOS settings.
> > + * Documentation:
> >   *
> > - * 40-41
> > - * 42-43
> > - * 
> > - *                 41
> > - *                 43
> > - *
> > - * | PIO 0       | c0 | 80 | 0 |
> > - * | PIO 2 | SW2 | d0 | 90 | 4 |
> > - * | PIO 3 | MW1 | e1 | a1 | 9 |
> > - * | PIO 4 | MW2 | e3 | a3 | b |
> > - *
> > - * sitre = word40 & 0x4000; primary
> > - * sitre = word42 & 0x4000; secondary
> > - *
> > - * 44 8421|8421    hdd|hdb
> > - *
> > - * 48 8421         hdd|hdc|hdb|hda udma enabled
> > - *
> > - *    0001         hda
> > - *    0010         hdb
> > - *    0100         hdc
> > - *    1000         hdd
> > - *
> > - * 4a 84|21        hdb|hda
> > - * 4b 84|21        hdd|hdc
> > - *
> > - *    ata-33/82371AB
> > - *    ata-33/82371EB
> > - *    ata-33/82801AB            ata-66/82801AA
> > - *    00|00 udma 0              00|00 reserved
> > - *    01|01 udma 1              01|01 udma 3
> > - *    10|10 udma 2              10|10 udma 4
> > - *    11|11 reserved            11|11 reserved
> > - *
> > - * 54 8421|8421    ata66 drive|ata66 enable
> 
>     You could have left te progarmming info intact...

Well, I thought about that but:

* It referenced ATA devices using hd[a-d] naming which while matches with
  most of use cases is not 100% correct (piix driver can be modular etc).

* Right below there is a note about the official Intel documentation
  (which is publically available).

* The piix.c code is self-documenting nowadays (in large parts thanks to
  your efforts). :)

Thanks,
Bart
