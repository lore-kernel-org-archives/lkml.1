Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXDEQaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXDEQaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXDEQaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:30:11 -0400
Received: from bay0-omc3-s39.bay0.hotmail.com ([65.54.246.239]:35932 "EHLO
	bay0-omc3-s39.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbXDEQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:30:08 -0400
Message-ID: <BAY113-DAV11F86E1B1E91A799AB05E9B9650@phx.gbl>
X-Originating-IP: [128.100.5.117]
X-Originating-Email: [gonwg@hotmail.com]
From: "Michael" <gonwg@hotmail.com>
To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Cc: <linux-kernel@vger.kernel.org>
References: <BAY113-DAV124C8565330DC6C51B2B09B9660@phx.gbl> <Pine.LNX.4.61.0704041246010.5035@chaos.analogic.com>
Subject: Re: set up new kernel with grub
Date: Thu, 5 Apr 2007 12:28:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	reply-type=original
Content-Transfer-Encoding: 7BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
X-OriginalArrivalTime: 05 Apr 2007 16:30:07.0867 (UTC) FILETIME=[AC5D9CB0:01C7779F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dick,

Your steps work beautifully. Thanks.

If you could explain a little about what happens in each step, that 
would be even better.

> # cd /usr/src/linux-2.6.20.3
> If your current kernel is 2.6.20.3, edit the Makefile to
> add some character after "EXTRAVERSION" as EXTRAVERSION= 3x
> # cp .config ..
> # make distclean
> # cp ../.config .
> # make oldconfig
> # make
> # make modules_install
> # make install


Regards,

Mike


----- Original Message ----- 
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Michael" <gonwg@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>
Sent: Wednesday, April 04, 2007 10:53 AM
Subject: Re: set up new kernel with grub


>
> On Wed, 4 Apr 2007, Michael wrote:
>
>> Hi,
>>
>> I compiled a new kernel: 2.6.20.3, and hope to test it without 
>> removing
>> my old kernel.
>
> You don't need to remove your old kernel. Log in as root.
>
> # cd /usr/src/linux-2.6.20.3
> If your current kernel is 2.6.20.3, edit the Makefile to
> add some character after "EXTRAVERSION" as EXTRAVERSION= 3x
> # cp .config ..
> # make distclean
> # cp ../.config .
> # make oldconfig
> # make
> # make modules_install
> # make install
>
> The result will put the new kernel in the GRUB menu so you can
> always go back to the old one if the new one doesn't work.
>
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.16.24 on an i686 machine (5592.65 
> BogoMips).
> New book: http://www.AbominableFirebug.com/
> _
> 
>
> ****************************************************************
> The information transmitted in this message is confidential and may be 
> privileged.  Any review, retransmission, dissemination, or other use 
> of this information by persons or entities other than the intended 
> recipient is prohibited.  If you are not the intended recipient, 
> please notify Analogic Corporation immediately - by replying to this 
> message or by sending an email to DeliveryErrors@analogic.com - and 
> destroy all copies of this information, including any attachments, 
> without reading or disclosing them.
>
> Thank you.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

