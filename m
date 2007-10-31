Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXJ3Vst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXJ3Vst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbXJ3Vsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:48:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:36893 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXJ3Vsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=NYYwSXTQS/9ox9JZtQBieNqAFZvz3DUAK9O60imrL3FlSXSokRC/e9fBrhYBMKEczgC9owdIMDiVVPuW+5rM4QkDgfslIRGmTd6y/jwLzFOO8wRaCm57/hE1+pHDrI8qJv8+3f7dU58xd+pCInoIGtgvXHCGVMJaMFVcTFeuRcQ=
Date: Tue, 30 Oct 2007 23:48:47 -0700
To: Norbert Preining <preining@logic.at>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-Id: <20071030234847.c651c96c.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071030204720.GI8479@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
	<20071030211729.6a80a93a.Kristoffer.ericson@gmail.com>
	<20071030204720.GI8479@gamma.logic.tuwien.ac.at>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 21:47:20 +0100
Norbert Preining <preining@logic.at> wrote:

> Hi Kristoffer,
> 
> thanks for the feedback.
> 
> On Di, 30 Okt 2007, Kristoffer Ericson wrote:
> > Im using a Huawei E220 USB modem, currently running 2.6.22.5 vanilla kernel. It has worked fine for me since 2.6.21.
> 
> Strange. I rebuilt the kernel, compiled the usb serial and options into
> the kernel, while leaving usb-storage as module. Still I have to issue
> the huaweiAktBbo program to get it working/switching into the *right*
> modus.
> 
> > The lights give you a hint what mode its in. Green = usb_storage, Dark-blue = MODEM_slow, bright-blue = MODEM_fast (3G).
> 
> BTW, I have seen a slightly different pattern: Green blinking from the
> beginning
I get green blinking up to udev, then it turns into dark blue.

> calling huaweiAktBbo to make the switch
> still blinking green
> calling the internet provider
> when the connection is established (on the hardware level, not on ip
> level) the modem starts blinking blue and then solid blue
> turning off the ppp connection it goes into blinking blue mode
> 
I have no experience with huewaiAktBbo, I just use wvdial, works nicely.
Solid color also symbolises "Established mode" for me.

> > If the light is green after reboot, I need to reboot again until it turns blue. I know this sucks, but just something I've noticed.
> 
> Probably you could use the huaweiAktBbo program for this, too.
> 
I've noticed that it depends on the USB host somehow. On my laptop I need to restart 3 times before it will go into "blue mode" properly. On my primary PC though, it always works right away. No idea why and haven't had the time to bugtrack it.

> Best wishes
> 
> Norbert
> 
> -------------------------------------------------------------------------------
> Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
> Debian Developer <preining@debian.org>                         Debian TeX Group
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> HASELBURY PLUCKNETT (n.)
> A mechanical device for cleaning combs invented during the industrial
> revolution at the same time as Arkwright's Spinning Jenny, but which
> didn't catch on in the same way.
> 			--- Douglas Adams, The Meaning of Liff
