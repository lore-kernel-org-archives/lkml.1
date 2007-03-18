Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbXCRADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbXCRADe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXCRADe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:03:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:41801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbXCRADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Gh3Lxpx1NEyywzpapQy6Ha70WpgkyHcUwVxNe+V5CC2iYnvPc44vPUBPr/ngaG6EjxOo0OpcSs+PJi5xlz5yP4XC+wDZyTfIZQJQ00EQl3XhENBbnFOd9MsDhlVHWPQWkQbnjgYd7aV6++nDkUYnl1GiJvxRkgMZKrqC3KeG1HQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Patrick Ringl <patrick_@freenet.de>
Subject: Re: [PATCH UPDATED] cosmetic adaption of drivers/ide/Kconfig concerning SATA
Date: Sun, 18 Mar 2007 01:10:51 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <45FC763B.1010708@freenet.de>
In-Reply-To: <45FC763B.1010708@freenet.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703180110.51303.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 18 March 2007, Patrick Ringl wrote:
> Hello,

Hi,

> since especially Serial ATA has it's own menu point now, I guess we can 
> change the description of the deprecated SATA driver as well, since the 
> new libATA subsystem is not configured through a SCSI low-level driver 
> anymore, but has it's own menu point.
> 
> The following patch is against 2.6.21-rc4:
> 
> --- linux-2.6.20.old/drivers/ide/Kconfig	2007-03-18 00:05:11.000000000 +0100
> +++ linux-2.6.20/drivers/ide/Kconfig	2007-03-18 00:09:47.000000000 +0100
> @@ -103,7 +103,7 @@
>   	---help---
>   	  There are two drivers for Serial ATA controllers.
> 
> -	  The main driver, "libata", exists inside the SCSI subsystem
> +	  The main driver, "libata", exists inside the ATA subsystem

Strictly speaking libata is not a separate subsystem (it still uses SCSI
subsystem) and "ATA subsystem" may be misleading, since we now have:

* "ATA/ATAPI/MFM/RLL support" menu for drivers/ide

* "Serial ATA (prod) and Parallel ATA (experimental) drivers" menu for libata

What about replacing "exists inside" into "uses" and adding info about
the new menu instead?

Thanks,
Bart
