Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXJ3TTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXJ3TTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXJ3TS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:18:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:62781 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbXJ3TS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=GxE5mWZxHABm5+s5e7r52X/pXQ2OSIEB0ruBevbSgf5pGDT0wZspdFhUMw2WNd+7ozyJSxzGTMNVD37330DS9MBpKJHQqjlrGXC/6zraVTBro4jhLxtGAqkgBqRjELqLrKuuZzqADHfSt4Jk0NQGHRO1/j1KAcoLjkOEeeFlLC8=
Date: Tue, 30 Oct 2007 21:17:29 -0700
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-Id: <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Im using a Huawei E220 USB modem, currently running 2.6.22.5 vanilla kernel. It has worked fine for me since 2.6.21.
The lights give you a hint what mode its in. Green = usb_storage, Dark-blue = MODEM_slow, bright-blue = MODEM_fast (3G).

If the light is green after reboot, I need to reboot again until it turns blue. I know this sucks, but just something I've noticed.

One hint is to put the USB modem as static in kernel and usb_storage as module.

Best wishes
Kristoffer Ericson


On Tue, 30 Oct 2007 20:09:45 +0100
Norbert Preining <preining@logic.at> wrote:

> Dear all,
> 
> I recently got an Huawei E220 usb modem. Reading a bit on the net I
> found that:
> 
>   The Huaweii E220 modem is a composite USB device: in fact it acts like a
>   mass storage device, and also as three serial communication ports. The
>   Linux's developers dealt with this ignoring the mass device storage
>   (which is a read-only mass storage, i.e. a CD-ROM with preload software
>   only for Windows). For more information see 
>   http://www.kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.20-rc2  or
>   http://lwn.net/Articles/220545/  where you read the changelog for 2.6.20
>   linux kernel. The interesting part is reported here below:
> 
>   [...]
>   Johann Wilhelm (2): usb-storage: Ignore the virtual cd-drive of the
>   Huawei E220 USB Modem usb-gsm-driver: Added VendorId and ProductId for
>   Huawei E220 USB Modem
>   [...]
> 
>   This modification is present from Linux kernel 2.6.20 and more recent
>   ones. 
> 
> See: http://ske.sourceforge.net/html/projects/huawei/huawei_tre.html
> 
> Now that I plug my modem I definitely get this usb storage device, and I
> need to call a special program to switch to the other mode
> (huaweiAktBbo, from 
> http://www.kanoistika.sk/bobovsky/archiv/umts/huaweiAktBbo.c).
> 
> Several pages on the web state that it should work *without* this switch
> program.
> 
> Is this a regression from 2.6.20, or is it supposed to work?
> 
> Thanks a lot and all the best
> 
> Norbert
> 
> -------------------------------------------------------------------------------
> Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
> Debian Developer <preining@debian.org>                         Debian TeX Group
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> DEAL (n.)
> The gummy substance found between damp toes.
> 			--- Douglas Adams, The Meaning of Liff
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
