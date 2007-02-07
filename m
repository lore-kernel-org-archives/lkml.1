Return-Path: <linux-kernel-owner+w=401wt.eu-S1161269AbXBGMHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161269AbXBGMHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161264AbXBGMHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:07:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56969 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161263AbXBGMHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:07:18 -0500
Date: Wed, 7 Feb 2007 12:20:00 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Luigi Genoni <genoni@sns.it>
Cc: linux-ide@vger.kernel.org, jgarzik@pobox.com, htejun@gmail.com,
       alan@red-hat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new
 pata driver, NV CK804 ide controller.
Message-ID: <20070207122000.2e17ecb6@localhost.localdomain>
In-Reply-To: <200702070119.36320.genoni@darkstar.oltrelinux.com>
References: <200702070119.36320.genoni@darkstar.oltrelinux.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 01:19:36 +0100
Luigi Genoni <genoni@sns.it> wrote:

> Hi,
> since upgrading to kernel 2.6.20 my pata disk, using new pata driver, is
> initialized maximum  in DMA33 mode (and obviously performances drop 
> consequently), as you can see from:

Interesting.

> Willing to test any patch.

Firstly can you see if its consistently the case that booting 2.6.20
gives UDMA33 and 2.6.19 UDMA100 over a few reboots. If it is please drop
the 2.6.19 drivers/ata/pamd_amd into 2.6.20 and try that.

Thanks

Alan
