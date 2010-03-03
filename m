Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0CCRp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:45:26 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:34096 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754875Ab0CCRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:45:25 -0500
Date: Wed, 3 Mar 2010 20:45:23 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] ahci: Move generic code into libahci
Message-ID: <20100303174523.GA15173@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
 <20100303171747.GI12362@oksana.dev.rtsoft.ru>
 <4B8E9D7B.6040709@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B8E9D7B.6040709@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 08:33:47PM +0300, Sergei Shtylyov wrote:
[...]
> >diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> >index b7d4923..75e3abd 100644
> >--- a/drivers/ata/Makefile
> >+++ b/drivers/ata/Makefile
> >@@ -1,7 +1,7 @@
> > obj-$(CONFIG_ATA)		+= libata.o
> >-obj-$(CONFIG_SATA_AHCI)		+= ahci.o
> >+obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
> 
>   This means 2 different modules: libahci.ko and ahci.ko.

Right you are. And we can't do ahci-objs += libahci.o ahci.o,
since that would be a circular dependency. Oh well, I'll merge
09 and 10 patches.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
