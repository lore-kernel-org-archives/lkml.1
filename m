Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXC1RtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXC1RtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965551AbXC1RtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:49:23 -0400
Received: from zotz.mtu.ru ([195.34.34.227]:4947 "EHLO zotz.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965164AbXC1RtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:49:22 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2007 13:49:22 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Testing patch for ALi PATA - fixes hopefully for the problems with ATAPI DMA
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Date: Wed, 28 Mar 2007 21:37:41 +0400
References: <20070327190248.01bc7e5c@the-village.bc.nu>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070328173742.B1E87619EC2@zotz.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> 
> This implements two things at driver level which are implemented
> implicitly by the old IDE layer
> 
> - Only doing sector sized ATAPI I/O via DMA
> - Alway writing the size values
> 
> Hopefully this will make CD devices behave better for those with the
> problems.

I am sorry to report that this did not change anything - I still get the
same timeouts on system boot during CD-ROM detection. To remind:

00:07.0 ISA bridge: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin
IV/V/V+]
scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0 DA3O PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 1313 PQ: 0 ANSI: 5

BTW should not libata fail back to PIO if all DMA fails? It never does for
me; this is strange.

I am tempted to test ACPI driver if you have patch suitable for mainstream
(not -mm)

thank you

-andrey


