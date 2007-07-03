Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXGCVMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXGCVMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbXGCVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:12:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57011 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752176AbXGCVMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:12:35 -0400
Date: Tue, 3 Jul 2007 17:12:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur <caglar@pardus.org.tr>
cc: Oliver Neukum <oliver@neukum.org>, "Ni@m" <niam.niam@gmail.com>,
       <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] for NIKON D50 as UMS
In-Reply-To: <200707040002.09025.caglar@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0707031710570.8010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, [utf-8] S.Çağlar Onur wrote:

> Hi,
> 
> 03 Tem 2007 Sal tarihinde, Oliver Neukum şunları yazmıştı: 
> > Am Dienstag, 3. Juli 2007 schrieb S.Çağlar Onur:
> > > Hmm i have NIKON D50 also and it works here without a problem with
> > > Linus's current git.
> >
> > Please provide the full lsusb -v for your devices, both of you.
> > You might have different versions of the device.
> 
> Here it is;
> 
> 
> Bus 005 Device 007: ID 04b0:0409 Nikon Corp. 
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0        64
>   idVendor           0x04b0 Nikon Corp.
>   idProduct          0x0409 
>   bcdDevice            1.00

The descriptors are the same.  But that doesn't mean anything.  It's 
possible that one device has a problem and the other doesn't because 
one computer tries to read the last sector and the other computer 
doesn't.  Or perhaps the two cameras have different capacities.

Alan Stern

