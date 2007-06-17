Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbXFQVgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbXFQVgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXFQVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:36:36 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:12879 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbXFQVgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=OBV8xWTFj5uFC4gX/9NEJDP2o+HGsCxfSRS0A3T8N+uEKILJz6PAtzgG1EuOaSqW/ImmsAOcHSBT6r0l4EHv9kiKf+Li/WrFAt7ysdg9hEzloARUqpUOx35hLHT9oTNSl69JaqliqgoJcKClGZjExxJSdjBjGWLC+EOHYsvdD0c=
Message-ID: <4675A948.80007@googlemail.com>
Date: Sun, 17 Jun 2007 23:36:08 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Maurizio Monge <maurizio.monge@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Add new ICH9M pci id (8086:2850) to ata_piix id list
References: <e4c519350706171423ldf77f77ve7080c213e6ec3fc@mail.gmail.com>
In-Reply-To: <e4c519350706171423ldf77f77ve7080c213e6ec3fc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maurizio Monge pisze:
> To make ata_piix recognize my ich9m chip i had to apply the
> modification that follows.
> 
> Best regards
> Maurizio Monge
> 
> 
> diff -Nurb old/drivers/ata/ata_piix.c new/drivers/ata/ata_piix.c
> --- old/drivers/ata/ata_piix.c  2007-06-17 23:06:12.000000000 +0200
> +++ new/drivers/ata/ata_piix.c  2007-06-17 23:15:57.000000000 +0200
> @@ -243,6 +243,8 @@
>        { 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
>        /* SATA Controller IDE (ICH9M) */
>        { 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
> +       /* Mobile SATA Controller IDE (ICH9M) */
> +       { 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
                      ^^^^
http://pci-ids.ucw.cz/iii/?i=80862850

Is this really a SATA controller?
((ICH8M/ICH8M-E) IDE Controller)

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
