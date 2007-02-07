Return-Path: <linux-kernel-owner+w=401wt.eu-S1422666AbXBGXve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422666AbXBGXve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422790AbXBGXve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:51:34 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:16380 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422666AbXBGXvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:51:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=CiDhZlFrrM97OoBkrDvgDCUpRl07k5XnqXIJC5WRk/0OJqzAXgLaU2AC73mZQuTZH71c6ceQYuw3XbZPYQr253GD04sEBsBxLMI0h1BYAgSElWa6f0o7EXQ7WijGYZP2D7gtx/3Mqbba8B4p7jTNg7d+RK3zT53HsPkJFhPsLYI=
Message-ID: <45CA6602.10909@googlemail.com>
Date: Thu, 08 Feb 2007 00:51:30 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-02-06-16-59.tar.gz uploaded
References: <200702070059.l170xPY0002614@shell0.pdx.osdl.net>	 <45CA0065.80705@fr.ibm.com>	 <6bffcb0e0702071403v767681edk2179fdb968b57e5a@mail.gmail.com>	 <20070207141532.9c1ac548.akpm@linux-foundation.org> <6bffcb0e0702071512i2567a2br3a873921b0d3d308@mail.gmail.com>
In-Reply-To: <6bffcb0e0702071512i2567a2br3a873921b0d3d308@mail.gmail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> On 07/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> I copied it to
>> http://userweb.kernel.org/~akpm/broken-out-2007-02-06-16-59.tar.gz but
>> there's really not much point in using it - it's ancient.
> 
> Cedric, here is an updated version
> http://www.stardust.webpages.pl/files/mm-snapshot/mm-snapshot-07-02-07-22-21.tar.bz2
> 
> 
> Without four patches
> 
> #swiotlb-uninlinings.patch
> #git-cryptodev-fixup.patch
> #add-vm_insert_pfn.patch
> #knfsd-fix-a-race-in-closing-nfsd-connections.patch

"Warning! Found recursive dependency: ACPI_DOCK ACPI_DOCK"

Fixed.

Regards,
Michal


-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/drivers/acpi/Kconfig	2007-02-08 00:46:05.000000000 +0100
+++ linux-work/drivers/acpi/Kconfig	2007-02-08 00:41:40.000000000 +0100
@@ -151,7 +151,6 @@ config ACPI_FAN
 config ACPI_DOCK
 	tristate "Dock"
 	depends on EXPERIMENTAL
-	depends on ACPI_DOCK
 	help
 	  This driver adds support for ACPI controlled docking stations


