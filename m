Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbXHUXM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbXHUXM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXHUXMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:12:19 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:48001 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbXHUXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:12:18 -0400
Message-ID: <46CB702D.8020102@gmail.com>
Date: Wed, 22 Aug 2007 01:07:25 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: =?ISO-8859-15?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= 
	<jopan@alumni.uv.es>,
       linux-kernel@vger.kernel.org
Subject: Re: Problems with IDE on linux 2.6.22.X
References: <200708212149.12912.jopan@alumni.uv.es>	<46CB626F.8020801@gmail.com> <20070822000003.6c561407@the-village.bc.nu>
In-Reply-To: <20070822000003.6c561407@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2007 01:00 AM, Alan Cox wrote:

>> "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
> 
> Not for the newer chips. You want ATA/SATA (PIIX and possibly AHCI)
> support from the new drivers, SCSI disk and SCSI cd.

That _is_ the *config description for the new (CONFIG_ATA_PIIX) driver (in 
2.6.22.x).

>> where you may need to boot with a "libata.atapi_enabled=0" kernel parameter.
> 
> Why deliberately disable atapi when you need atapi ?

Because he described the problem that if he got his (SATA) disk supported he 
lost his (PATA) DVD drive. Although I'm as said not completely sure it would 
actually work, I suggested compiling in both ATA_PIIX (yes, and sd) for his 
drive and the IDE PIIX/ICH driver and ide-cd for his DVD, where if it works 
at all, passing the above option may or may not be useful.

But his report, although expansive, was a little unclear. Let's wait for 
what happens with only ATA_PIIIX.

Rene.
