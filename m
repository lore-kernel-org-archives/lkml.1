Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXINWDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXINWDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 18:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbXINWDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 18:03:43 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:57605 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbXINWDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 18:03:42 -0400
Date: Sat, 15 Sep 2007 07:02:34 +0900
To: stefanr@s5r6.in-berlin.de
Cc: lsorense@csclub.uwaterloo.ca, james.bottomley@steeleye.com,
       linux-scsi@vger.kernel.org, jeff@garzik.org, andi@firstfloor.org,
       folkert@vanheusden.com, bunk@kernel.org, linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH update] SCSI: update Kconfig help text to indicate SCSI
 core's widespread usage
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <tkrat.0e73b94c1e80a481@s5r6.in-berlin.de>
References: <20070914202102.GE5386@csclub.uwaterloo.ca>
	<tkrat.f4379d6e5f1ce499@s5r6.in-berlin.de>
	<tkrat.0e73b94c1e80a481@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070914031256T.tomof@acm.org>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 23:14:21 +0200 (CEST)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> 
> And one more update:
> There is SAS too, and I forgot 'is' in "on a disk which __ accessed via".
> 
>  drivers/scsi/Kconfig |   67 ++++++++++++++++++++++---------------------
>  1 file changed, 35 insertions(+), 32 deletions(-)
> 
> Index: linux-2.6.23-rc6/drivers/scsi/Kconfig
> ===================================================================
> --- linux-2.6.23-rc6.orig/drivers/scsi/Kconfig
> +++ linux-2.6.23-rc6/drivers/scsi/Kconfig
> @@ -12,23 +12,31 @@ config SCSI
>  	depends on BLOCK
>  	select SCSI_DMA if HAS_DMA
>  	---help---
> -	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
> -	  any other SCSI device under Linux, say Y and make sure that you know
> -	  the name of your SCSI host adapter (the card inside your computer
> -	  that "speaks" the SCSI protocol, also called SCSI controller),
> -	  because you will be asked for it.
> -
> -	  You also need to say Y here if you have a device which speaks
> -	  the SCSI protocol.  Examples of this include the parallel port
> -	  version of the IOMEGA ZIP drive, USB storage devices, Fibre
> -	  Channel, FireWire storage and the IDE-SCSI emulation driver.
> +	  This option enables core support for SCSI protocols.
> +	  You need it
> +	  - for classic parallel SCSI hardware,
> +	  - for newer SCSI transports such as Fibre Channel, FireWire storage,
> +	    SAS, or iSCSI,

There is SRP too.
