Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbXIDVhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbXIDVhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 17:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXIDVhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 17:37:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:18722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbXIDVhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 17:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cawsopENh9adCTeIrxjh/fsmCGRQGmTs8bIxeUbgrhFcBPV3OCfh9VWnOg2aILRU0+tvrWyB2uUrVxEe2N0qFG0DV6XcoUww6drwhxkEJXnEV88Ap35YsG3inf0slJ2uc7dChHVVXTu3edb8n1u6ASkY0NqFKFt56aio9DwSTM8=
Message-ID: <ab40e9c0709041437m13b12b47r1461d3b9bba68a99@mail.gmail.com>
Date: Tue, 4 Sep 2007 23:37:08 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: ramdisk
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0709041101290.7968@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0709030604u5fecf34dr945ece01b95e622d@mail.gmail.com>
	 <Pine.LNX.4.61.0709041101290.7968@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dick,
Thanks for the reply.

then how to create these device nodes in /dev? from the information i
got from the cosole(unknown block(1,0) ), it seems that I didn't
create the device? I thought the kernel should do this work right? if
not how to create it?

thanks,

regards,


2007/9/4, linux-os (Dick Johnson) <linux-os@analogic.com>:
>
> On Mon, 3 Sep 2007, Xu Yang wrote:
>
> > Hi everyone,
> >
> > I want to use ramdisk to boot my filesystem, as I can't use NFS and harddisk.
> >
> > I have load the ramdisk into the ram memory (start address :0x4000000)
> >
> > and in the boot options I specified : root =dev/ram0 initrd=0x4000000
>
> Since you don't know what the default directory is, perhaps
> root should be /dev/ram0. Also, make sure you actually create
> those device nodes in /dev
>
> [Snipped...]
>
> > but the kernel said it can not find any file system on it.
> >
> > regards,
> >
> > Yang
> >
>
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
> My book : http://www.AbominableFirebug.com/
> _
>
>
> ****************************************************************
> The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.
>
> Thank you.
>
