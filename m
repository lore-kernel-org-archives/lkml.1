Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXBGMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXBGMoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbXBGMoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:44:21 -0500
Received: from vsmtp14.tin.it ([212.216.176.118]:41140 "EHLO vsmtp14.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933269AbXBGMoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:44:20 -0500
Date: Wed, 7 Feb 2007 13:44:16 +0100 (CET)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: linux-ide@vger.kernel.org, jgarzik@pobox.com, htejun@gmail.com,
       alan@red-hat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new
 pata driver, NV CK804 ide controller.
In-Reply-To: <20070207122000.2e17ecb6@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702071341350.28168@Phoenix.oltrelinux.com>
References: <200702070119.36320.genoni@darkstar.oltrelinux.com>
 <20070207122000.2e17ecb6@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I did the test you asked and yes, it is consistently booting at DMA33 with 
2.6.20 and DMA100 with 2.6.19.3 (20 reboots, 10 2.6.20 and 10 2.6.19 in 
sparse order).
I am compiling a 2.6.20 kernel with older pata_amd.c driver and will let 
you know. seeing the diff I do exspect it to compile cleanly.

Luigi


On Wed, 7 Feb 2007, Alan wrote:

> Date: Wed, 7 Feb 2007 12:20:00 +0000
> From: Alan <alan@lxorguk.ukuu.org.uk>
> To: Luigi Genoni <genoni@sns.it>
> Cc: linux-ide@vger.kernel.org, jgarzik@pobox.com, htejun@gmail.com,
>     alan@red-hat.com, linux-kernel@vger.kernel.org
> Subject: Re: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new pata
>      driver, NV CK804 ide controller.
> Resent-Date: Wed, 07 Feb 2007 13:17:42 +0100
> Resent-From: <l.genoni@sns.it>
> 
> On Wed, 7 Feb 2007 01:19:36 +0100
> Luigi Genoni <genoni@sns.it> wrote:
>
>> Hi,
>> since upgrading to kernel 2.6.20 my pata disk, using new pata driver, is
>> initialized maximum  in DMA33 mode (and obviously performances drop
>> consequently), as you can see from:
>
> Interesting.
>
>> Willing to test any patch.
>
> Firstly can you see if its consistently the case that booting 2.6.20
> gives UDMA33 and 2.6.19 UDMA100 over a few reboots. If it is please drop
> the 2.6.19 drivers/ata/pamd_amd into 2.6.20 and try that.
>
> Thanks
>
> Alan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
