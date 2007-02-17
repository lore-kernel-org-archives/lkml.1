Return-Path: <linux-kernel-owner+w=401wt.eu-S2992968AbXBQRqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992968AbXBQRqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992985AbXBQRqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:46:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:48923 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992968AbXBQRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:46:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=fDiUtnYVuY8myvcl9vAxh/bt3QxZ//op5TY9R3dg37RPRT7NqMLjgSZGkbaQNUEZk+frHnlq9X9DPf00GHhrMd93RuA5LHZXd91vlUHXII9BcOX02oXduGTVaZpZDgIi00Utz6Q5adw9NWbfy0UeXGbLbIp6TbwqEDtEql9LY50=
Message-ID: <45D73F62.20407@googlemail.com>
Date: Sat, 17 Feb 2007 18:46:10 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-02-17-03-25.tar.gz uploaded
References: <200702171127.l1HBRnhe025635@shell0.pdx.osdl.net>
In-Reply-To: <200702171127.l1HBRnhe025635@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-02-17-03-25.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-17-03-25.tar.gz
> 
> It contains the following patches against 2.6.20:
> 

arch/i386/kernel/mpparse.c: In function 'mp_register_gsi':
arch/i386/kernel/mpparse.c:1049: warning: unused variable 'pci_irq'

Remove unused variable.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff linux-work-clean/arch/i386/kernel/mpparse.c linux-work/arch/i386/kernel/mpparse.c
--- linux-work-clean/arch/i386/kernel/mpparse.c	2007-02-17 18:36:52.000000000 +0100
+++ linux-work/arch/i386/kernel/mpparse.c	2007-02-17 18:36:45.000000000 +0100
@@ -1046,7 +1046,6 @@ int mp_register_gsi(u32 gsi, int trigger
 	int ioapic = -1;
 	int ioapic_pin = 0;
 	int idx, bit = 0;
-	static int pci_irq = 16;

 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)


