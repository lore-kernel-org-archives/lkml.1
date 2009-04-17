Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbZDQK0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbZDQK0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbZDQK0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:26:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53663 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756870AbZDQK0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:26:14 -0400
Date: Fri, 17 Apr 2009 11:27:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] v3 fix error on drivers/ata/pata_legacy.c
Message-ID: <20090417112713.04ed51d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090417073259.GA6366@helight>
References: <20090417073259.GA6366@helight>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 15:32:59 +0800
Zhenwen Xu <helight.xu@gmail.com> wrote:

> fix those errors:
> 
> drivers/ata/pata_legacy.c: In function ‘pdc_data_xfer_vlb’:
> drivers/ata/pata_legacy.c:289: error: ‘ap’ undeclared (first use in this function)
> drivers/ata/pata_legacy.c:289: error: (Each undeclared identifier is reported only once
> drivers/ata/pata_legacy.c:289: error: for each function it appears in.)
> drivers/ata/pata_legacy.c: At top level:
> drivers/ata/pata_legacy.c:869: error: ‘ATA_PFLAG_PIO32_CHANGE’ undeclared here (not in a
> +function)
> make[2]: *** [drivers/ata/pata_legacy.o] Error 1
> make[1]: *** [drivers/ata] Error 2

Looks good to me. I shall have to find something larger than PROPOSED in
the patch title to stop Jeff applying things that were discussion code

Acked-by: Alan Cox <alan@linux.intel.com>
