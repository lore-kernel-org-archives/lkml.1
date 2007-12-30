Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbXL3Ck6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbXL3Ck6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 21:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXL3Ckr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 21:40:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:10355 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbXL3Ckq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 21:40:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kWrcWitzZ4oJWQQkCDdi3DUqxDAnw9+58uzzscCLpFwx4AZITnygj14lQXLWzGiLcd3wjJdJhVRFk868voRBd8Oj7XvtOrr4qRWDszfzvI2dsOXFv1G5qLo62P5cqdMFeAx+1xTSM/8O74GghSpGWXqPwv0mRtxy6Lp6VuhYt2M=
Message-ID: <a276da400712291840m7d90d6fr5d80f21a04a1c1b3@mail.gmail.com>
Date: Sun, 30 Dec 2007 10:40:45 +0800
From: "Xiaofan Chen" <xiaofanc@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [RFC] USB driver for talking to the Microchip PIC18 boot loader
Cc: mgross <640e9920@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229193409.GA20188@mgross-t43>
	 <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 6:15 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 29 Dec 2007, mgross wrote:
>
> > I'm playing around with a PIC based project at home (not an Intel
> > activity) and found I needed a usb driver to talk to the boot loader
> > so I can program my USB Bitwhacker with new custom firmware.  The
> > following adds the pic18bl driver to the kernel.  Its pretty simple
> > and is somewhat based on bits of a libusb driver that does some of
> > what this driver does.
> >
> > What do you think?
>
> Not to detract from your driver, but would it be possible to do the
> whole thing in userspace using libusb?  Maybe by extending the driver
> you mentioned?
>

The existing libusb based application works fine for PICDEM FS USB
or those based on it (like the Bitwhacker the OP is using).

Please do not add it to the kernel. There are libusb based application
for both the bootloader and the demo application and both are working
fine under Linux (along with Windows and I am trying to get FreeBSD
working).

Last time the demo application has been added to the ldusb and
I think it is not a good idea. But since then I've added patches to
the existing libusb application.

Relevant discussion in thread
'[PATCH 70/78] USB: add picdem device to ldusb'
http://marc.info/?t=117770076400003&r=1&w=2

So please do not do this again. It is not a problem for the libusb
based applications after the patches but it is really not necessary.

Original libusb based application for the bootloader:
http://www.internetking.org/fsusb/

Original libusb based application for the Demo which
also includes my patch for libusb-win32.
http://www.varxec.net/picdem_fs_usb/

Updated Patches to detach the kernel driver for both
the bootloader and Demo application.
http://forum.microchip.com/tm.aspx?m=106426

Xiaofan Chen
http://mcuee.blogspot.com
