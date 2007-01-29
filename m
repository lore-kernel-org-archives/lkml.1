Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbXA2VBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbXA2VBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXA2VBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:01:33 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:62510 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbXA2VBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:01:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BEopTrsqF8+kzA8ueHuWV56JT168q65ztaGm6RhPCknJxSbym2DMXYgkPQlViPwX7iu/lpp2kJ2pFR4t9br8wgDWzQC1oG9Mc3CcsdC2jJkgIhSxDw/Bs4c2G9RyG5wbDtMGp8/hNSrwnNS6st/7WRhdaUiUZ1E3GWhu3qDGKFE=
Message-ID: <8d158e1f0701291301q18040b76t162bf09cca16660b@mail.gmail.com>
Date: Mon, 29 Jan 2007 22:01:32 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Boot problems with pata_via driver
In-Reply-To: <8d158e1f0701291253u38607480m597d32815143c5e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0701280347l1d778528la0d69647726485d6@mail.gmail.com>
	 <20070128231147.GA6017@stusta.de>
	 <8d158e1f0701282330o3591a226lb664644ffdb025f0@mail.gmail.com>
	 <8d158e1f0701282332m3e22a649s621abc258c6103d5@mail.gmail.com>
	 <8d158e1f0701291253u38607480m597d32815143c5e6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> Okay so, I unplugged the keyboard the moment I selected a kernel to boot.
> The last thing i see on my screen, regarding SCSI is:
>
> scsi 0:0:0:0: Direct-Access       ATA      WDC WD2000JB-00G 08.0 PQ: 0 ANSI: 5
> scsi 1:0:0:0 CD-ROM               AOPEN DUW1608/ARR         A060 PW: 0 ANSI: 5

Funny, when I look at my dmesg log when I boot the 2.6.19 kernel (which works)
then I seem to miss something in the kernel output when I boot the
2.6.20 kernel.

When I boot 2.6.19 I see:
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JB-00G 08.0 PQ: 0 ANSI: 5
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0

Does 2.6.20 see my IDE bus but it doesnt probe for drives?


Patrick
