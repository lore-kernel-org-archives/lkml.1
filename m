Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbZFXQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbZFXQih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZFXQib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:38:31 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4637 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbZFXQib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:38:31 -0400
Subject: Re: [PATCH] pata_rdc: driver for RDC ATA devices
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, kevin.huang@rdc.com.tw, greg@kroah.com
In-Reply-To: <20090624170944.24250.99267.stgit@t61.ukuu.org.uk>
References: <20090624170944.24250.99267.stgit@t61.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 09:38:23 -0700
Message-Id: <1245861503.29098.102.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 18:10 +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
> new file mode 100644
> index 0000000..0f40cab
> --- /dev/null
> +++ b/drivers/ata/pata_rdc.c
[]
> +static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
> +{
[]
> +	static const	 /* ISP  RTC */
> +	u8 timings[][2]	= { { 0, 0 },
> +			    { 0, 0 },
> +			    { 1, 0 },
> +			    { 2, 1 },
> +			    { 2, 3 }, };
[]
> +static void do_rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
> +{
> +	static const	 /* ISP  RTC */
> +	u8 timings[][2]	= { { 0, 0 },
> +			    { 0, 0 },
> +			    { 1, 0 },
> +			    { 2, 1 },
> +			    { 2, 3 }, };

Maybe consolidate?

The code seems to have many magic constants that might
be better #define'd and or'd.

