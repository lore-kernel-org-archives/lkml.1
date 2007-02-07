Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXBGKaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXBGKaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161157AbXBGKaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:30:07 -0500
Received: from outmx007.isp.belgacom.be ([195.238.5.234]:56078 "EHLO
	outmx007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbXBGKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:30:06 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: Free Linux Driver Development!
Date: Wed, 7 Feb 2007 11:30:51 +0100
User-Agent: KMail/1.9.5
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20070130012904.GA9617@kroah.com> <20070130195445.GE22022@kroah.com> <adazm80p4qp.fsf@cisco.com>
In-Reply-To: <adazm80p4qp.fsf@cisco.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071130.52108.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > > I have a Cisco USB webcam that supposedly conforms to the "USB Video
>  > > Device Class", but nothing happens when I plug it into my Linux box.
>  > > I assume the device class is specified as part of the USB spec...
>  >
>  > Are you sure?  That spec just came out not so long ago and I haven't
>  > seen any real devices support it just yet.  That said, I do know of a
>  > few people who are working on implementing the standard, try asking on
>  > the linux-usb-devel mailing list to find out what their status is.
>
> A quick web search finds http://linux-uvc.berlios.de/ but I don't see
> any signs that anyone plans to submit it upstream.

If you want a sign, here it is: I plan to submit the driver upstream :-)

After more than a year of development, the Linux UVC driver is now stable 
enough to be included in the kernel. There is a show stopper though: V4L2.

The UVC specification defines a set of standard controls. Most of them are 
part of the V4L2 specification as well (brightness, contrast, ...), but some 
of them aren't. Those controls are currently exposed through private controls 
(which drivers are allowed to expose by V4L2), but I don't want to keep 
private controls around for standard controls defined by UVC.

Once V4L2 will be updated (hopefully soon, I keep trying :-)), I will submit 
the driver upstream.

Regards,

Laurent Pinchart
