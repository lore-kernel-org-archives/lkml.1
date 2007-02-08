Return-Path: <linux-kernel-owner+w=401wt.eu-S1422959AbXBHMdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422959AbXBHMdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422964AbXBHMdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:33:24 -0500
Received: from vsmtp21.tin.it ([212.216.176.109]:33546 "EHLO vsmtp21.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422959AbXBHMdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:33:23 -0500
Date: Thu, 8 Feb 2007 13:33:16 +0100 (CET)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: Robert Hancock <hancockr@shaw.ca>
cc: Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Luigi Genoni <genoni@sns.it>, l.genoni@sns.it
Subject: Re: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new
 pata driver, NV CK804 ide controller.
In-Reply-To: <45CAA8EA.2010505@shaw.ca>
Message-ID: <Pine.LNX.4.64.0702081332330.24105@Phoenix.oltrelinux.com>
References: <fa.xQT7YaGQERXkjuW4tC35jsdiTD0@ifi.uio.no>
 <fa.Bv1nbk8Z669RxoYF6zPFpsCsyd4@ifi.uio.no> <45CAA8EA.2010505@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, the cable is OK, of course I checked.

On Wed, 7 Feb 2007, Robert Hancock wrote:

> Date: Wed, 07 Feb 2007 22:36:58 -0600
> From: Robert Hancock <hancockr@shaw.ca>
> To: Alan <alan@lxorguk.ukuu.org.uk>,
>     linux-kernel <linux-kernel@vger.kernel.org>
> Cc: Luigi Genoni <genoni@sns.it>
> Subject: Re: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new pata
>      driver, NV CK804 ide controller.
> Resent-Date: Thu, 08 Feb 2007 05:47:22 +0100
> Resent-From: <l.genoni@sns.it>
> 
> Alan wrote:
>> On Wed, 7 Feb 2007 01:19:36 +0100
>> Luigi Genoni <genoni@sns.it> wrote:
>> 
>>> Hi,
>>> since upgrading to kernel 2.6.20 my pata disk, using new pata driver, is
>>> initialized maximum  in DMA33 mode (and obviously performances drop 
>>> consequently), as you can see from:
>> 
>> Interesting.
>> 
>>> Willing to test any patch.
>> 
>> Firstly can you see if its consistently the case that booting 2.6.20
>> gives UDMA33 and 2.6.19 UDMA100 over a few reboots. If it is please drop
>> the 2.6.19 drivers/ata/pamd_amd into 2.6.20 and try that.
>
> As an aside to this sort of problem, shouldn't we print some kind of loud 
> message in dmesg when we force a high-UDMA-capable device down to UDMA33 due 
> to a 40-wire cable detection? In the case where it truly is a 40-wire cable 
> the user may want to know that and replace the cable, if it isn't it gives 
> more of a hint of why the drive isn't running at full speed..
>
> -- 
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
