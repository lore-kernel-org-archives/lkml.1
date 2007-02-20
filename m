Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXBTQ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXBTQ45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030280AbXBTQ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:56:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45105 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241AbXBTQ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:56:56 -0500
Message-ID: <45DB2855.9010705@garzik.org>
Date: Tue, 20 Feb 2007 11:56:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] siimage: DRAC4 note
References: <20070220175600.43476be1@localhost.localdomain>
In-Reply-To: <20070220175600.43476be1@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> The Dell DRAC4 has some interesting features including effectively hot
> unplugging/replugging the virtual CD interface when the DRAC is reset.
> This often causes drivers/ide/siimage to panic but is ok with the rather
> smarter code in libata.
> 
> Just note this fact in the driver docs.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ide/pci/siimage.c linux-2.6.20-mm2/drivers/ide/pci/siimage.c
> --- linux.vanilla-2.6.20-mm2/drivers/ide/pci/siimage.c	2007-02-20 13:38:01.000000000 +0000
> +++ linux-2.6.20-mm2/drivers/ide/pci/siimage.c	2007-02-20 13:59:44.000000000 +0000
> @@ -26,6 +26,9 @@
>   *	If you have strange problems with nVidia chipset systems please
>   *	see the SI support documentation and update your system BIOS
>   *	if neccessary
> + *
> + *	If you are using a Dell DRAC4 you should use the libata driver
> + *	if possible.

IMO it would probably easier on all involved if the comment noted what 
you state in the patch description.

	Jeff



