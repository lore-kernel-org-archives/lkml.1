Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZGUKv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZGUKv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZGUKv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:51:27 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:38687 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbZGUKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kZdbHJn5Xei8Ti91yIdBiBZh1dmBJI6zX+9/5dQ4/qwuMjJXfJmneFC3+5Z0cmFF7s
         95f9wP+mWCQulLpcnLPIseXjmWRlhVDA61nz9drdyfc16cbzGwewHWs2F1adJV74seDz
         jDfBphiQAdajx8cuZtwVNtHEgNT8TbeqBLCMA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dwayne Rightler <drightler@technicalogic.com>
Subject: Re: No UDMA with BLK_DEV_IT821X with 2.6.30.2
Date: Wed, 22 Jul 2009 12:47:23 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090720-03987-ged696ea; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A64F7BA.2030900@technicalogic.com>
In-Reply-To: <4A64F7BA.2030900@technicalogic.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221247.24090.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009 01:03:22 Dwayne Rightler wrote:
> Hello,
> 
> I have a ITE8212 PCI card and it does not seem to allow UDMA on the 
> drives attached.  The drives run at ATA100 under other controllers.
> 
> Dmesg:
> 
> [    3.029612] it821x 0000:01:07.0: IDE controller (0x1283:0x8212 rev 0x13)
> [    3.029835] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
> [    3.029840] pci 0000:01:07.0: PCI INT A -> Link[APC4] -> GSI 19 
> (level, low) -> IRQ 19
> [    3.029847] it821x 0000:01:07.0: controller in smart mode

The controller is running in the "smart mode" in which it takes care
of setting the transfer speed (the driver reports standard MWDMA2 mode
to higher-layers for compatibility reasons).
