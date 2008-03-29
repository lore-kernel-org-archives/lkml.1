Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYC2SNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYC2SNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYC2SNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:13:06 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35402 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753113AbYC2SNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:13:05 -0400
Date: Sat, 29 Mar 2008 19:12:55 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for March 29
Message-ID: <20080329191255.7312e036@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080329223354.304e2722.sfr@canb.auug.org.au>
References: <20080329223354.304e2722.sfr@canb.auug.org.au>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2008 18:12:55.0418 (UTC) FILETIME=[82CF75A0:01C891C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Status of my local build tests is at
> http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

I see both avr32 builds currently fail, but for different
reasons...none of which is avr32-specific as far as I can tell.

defconfig fails with

drivers/ata/libata-core.c:127: error: 'ata_pci_default_filter' undeclared here (not in a function)

which seems to be due to CONFIG_ATA && !CONFIG_PCI

allnoconfig fails with

include/linux/netdevice.h:843: error: implicit declaration of function 'dev_net'

which seems to be because the definition of dev_net is inside #ifdef
CONFIG_NET, while next_net_device, which calls it, is not.

Haavard
