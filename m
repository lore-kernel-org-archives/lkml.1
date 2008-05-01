Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbYEAWCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbYEAWCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYEAWCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:02:33 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:49276 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbYEAWCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:02:32 -0400
Message-ID: <002301c8abd7$0d8afcf0$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <nadejdalevitsky@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <samuel.thibault@ens-lyon.org>,
       <eric.moore@lsil.com>
Subject: Re: This month's price for the most useless new Kconfig help text ...
Date: Fri, 2 May 2008 00:02:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX19MjokAxJAVXILpIcvOpcHeS0kJKBBYRXrHz6YK
	QErhp3GxOav3CP+mQOqYzibHkxZHCKY0TCfdYmGIgYzY9+kVM6
	h/hXgZ0PY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> (I agree that Kconfig helps like "CONFIG_FUSION: Say Y here to get to
>> see options for Fusion Message Passing Technology (MPT) drivers" do not
>> help much, I just didn't know that people were now actually caring about
>> having some real explanations beyond the usual "if you don't know what
>> it is, you don't need it, just say no")
>
>Speaking of which I remember how I was confused when I found out that this 
>driver
>is the linux driver for "SCI logic" SCSI vmware adapter :-)

to be exact, it`s  CONFIG_FUSION_SPI and that makes mptspi build, which is
a driver for LSI53C1030 type controller, which also exists in real world.
vmware just emulates this hardware.

>menuconfig FUSION
>        bool "Fusion MPT device support"
>        depends on PCI
>        ---help---
>        Say Y here to get to see options for Fusion Message
>        Passing Technology (MPT) drivers.
>        This option alone does not add any kernel code.

you are right, this is confiusing and confused me and others, too.

not a single word that this is for LSILogic type controllers.

Maybe that can/should be changed to "LSI Fusion MPT device support", "Say Y 
here to get to see options for drivers
based on LSI Fusion Message Passing Technology (MPT)"  !?

regards
roland






List:       linux-kernel
Subject:    Re: This month's price for the most useless new Kconfig help 
text ...
From:       Maxim Levitsky <nadejdalevitsky () gmail ! com>
Date:       2008-05-01 17:04:42
Message-ID: 200805012004.42706.maximlevitsky () gmail ! com
[Download message RAW]

On Thursday, 1 May 2008 19:01:29 Samuel Thibault wrote:
> Christoph Hellwig, le Thu 01 May 2008 11:47:20 -0400, a écrit :
> > On Thu, May 01, 2008 at 02:19:00PM +0100, Samuel Thibault wrote:
> > > If the society was a bit more aware of accessibility troubles in 
> > > general
> > > (I mean in the street etc.), we wouldn't have to explain the word
> >
> > Blah, an agenda is not an excuse for bad option descriptions.
>
> Sure, that's why I provided a patch :)
>
> (I agree that Kconfig helps like "CONFIG_FUSION: Say Y here to get to
> see options for Fusion Message Passing Technology (MPT) drivers" do not
> help much, I just didn't know that people were now actually caring about
> having some real explanations beyond the usual "if you don't know what
> it is, you don't need it, just say no")
Speaking of which I remember how I was confused when I found out that this 
driver
is the linux driver for "SCI logic" SCSI vmware adapter :-)

>
> > And btw, the word accessibility in the sense used here doesn't translate
> > at all into many foreign languages,
>
> Right.
>
> Samuel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
 Maxim Levitsky


