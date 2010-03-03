Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0CCNOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:14:50 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:32810 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753994Ab0CCNOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:14:48 -0500
Date: Wed, 3 Mar 2010 16:14:46 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] ahci: Add platform driver
Message-ID: <20100303131446.GA890@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
 <20100302182947.GL3445@oksana.dev.rtsoft.ru>
 <4B8D69D0.1050209@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B8D69D0.1050209@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 10:41:04PM +0300, Sergei Shtylyov wrote:
[...]
> >+static int __devinit ahci_probe(struct platform_device *pdev)
> 
>  Does it make sense to make this driver hotplug capable?

Probably not, at least for now. Will correct.

[...]
> >+	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
> 
>   Hm...

That was copied from the PCI driver.

> >+	ahci_set_em_messages(hpriv, &pi);
> >+
> >+
> 
>   Extra newline?

Yeah, that's all directly copied from the PCI driver. Will correct.

[...]
> >+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> 
>   Could also use platform_get_irq()...

OK.

> >diff --git a/drivers/ata/ahci_platform.h b/drivers/ata/ahci_platform.h
> >new file mode 100644
> >index 0000000..f7dd576
> >--- /dev/null
> >+++ b/drivers/ata/ahci_platform.h
> 
>   I doubt that it's good place for declaring the platform data which
> will be used by the platform code. This file should be somewhere in
> include/linux/, don't you think?

Will change.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
