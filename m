Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYG3Qri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYG3Qri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYG3Qra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:47:30 -0400
Received: from smtp.net4india.com ([202.71.129.73]:49101 "EHLO
	smtp.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYG3Qr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:47:29 -0400
Subject: Re: PCIe device driver question
From: "V.Radhakrishnan" <rk@atr-labs.com>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <257182.1206.qm@web31708.mail.mud.yahoo.com>
References: <257182.1206.qm@web31708.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 22:21:37 +0530
Message-Id: <1217436697.5232.7.camel@atlas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > am testing this in an X86_64 architecture machine with 4 GB of RAM. I
> > am able to successfully dma data into any memory (dma) address >
> > 0x0000_0001_0000_0000.

How can you DMA "successfully" into this address which is > 4 GB when
you have only 4 GB RAM ? Or am I missing something ?

V. Radhakrishnan
http://www.atr-labs.com

On Wed, 2008-07-30 at 09:09 -0700, Sanka Piyaratna wrote:
> Hi Alan,
> 
> Actually the failures occur at addresses lot higher than this range, I am noticing the failure at dma address 0x0000000037845000. This would be at around 900MB ?
> 
> Thanks
> 
> Sanka
> 
> 
> 
> ----- Original Message ----
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> To: Sanka Piyaratna <cesanka@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Thursday, 31 July, 2008 1:17:18 AM
> Subject: Re: PCIe device driver question
> 
> On Wed, 30 Jul 2008 09:00:58 -0700 (PDT)
> Sanka Piyaratna <cesanka@yahoo.com> wrote:
> 
> > Hi,
> > 
> > I am currently developing a PCIe data capture card hardware and the
> > device drivers to drive this. I have implemented DMA on the data
> > capture and the scatter-gather DMA is implemented in the hardware.  I
> > am testing this in an X86_64 architecture machine with 4 GB of RAM. I
> > am able to successfully dma data into any memory (dma) address >
> > 0x0000_0001_0000_0000. However, my problem is to dma data to any
> > address less than this. When I try to DMA data to an address less than
> > 0x0000_0001_0000_0000, the hardware device hangs indicating that the
> > address does not exist.
> 
> Assuming the failures are in the range 640K-1MB then I would imagine your
> bridge doesn't permit transfers via DMA to the ISA hole.
> 
> 
> 
>       Find a better answer, faster with the new Yahoo!7 Search. www.yahoo7.com.au/search
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

