Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYJ3He4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYJ3He4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYJ3Heq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:34:46 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:48014 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbYJ3Hep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:34:45 -0400
X-BigFish: VPS-70(z21eWz542N1432R98dR936eQ148cM1805M936fO3117K9371P241fmzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K9JJPB-03-93P-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Date: Thu, 30 Oct 2008 15:34:14 +0800
Message-ID: <B90463BC30D2E446BA423D888DC85E50E8C0EB@sshaexmb1.amd.com>
In-Reply-To: <20081030055410.GB19035@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Thread-Index: Ack6VEMgbkbTHVvFRceY2+G7Nu6s5gADWD3Q
References: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de> <20081030055410.GB19035@kroah.com>
From: "Yang, Libin" <Libin.Yang@amd.com>
To: "Greg KH" <greg@kroah.com>,
       "Volker Armin Hemmann" <volker.armin.hemmann@tu-clausthal.de>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       "Huang, Shane" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 30 Oct 2008 07:34:22.0578 (UTC) FILETIME=[ED644520:01C93A61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reporting this bug. We are trying to reproduce this bug and
will look into it.

Thanks & Regards,
Libin

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, October 30, 2008 1:54 PM
> To: Volker Armin Hemmann
> Cc: linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; Yang,
Libin;
> Cai, Crane
> Subject: Re: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb
lockup
> 
> On Thu, Oct 30, 2008 at 02:15:18AM +0100, Volker Armin Hemmann wrote:
> > Hi,
> >
> > I have a A770Crossfire board from Asrock.
> > With kernel 2.6.26.X and 2.6.27.[1,2,3,4] I have the following
problem
> that
> > makes usb mostly unusable.
> >
> > I have a 4 port hub attached. A logitech mouse receiver is inserted
into
> one
> > of its ports - it does not matter which one. Everything works fine.
> >
> > I turn on an external enclosure, which is either attached to one of
the
> > mainboards ports or the hub. Everything works for a couple of
seconds. I
> mount
> > the cdrom/harddisk partition and start copying a file - or just wait
a
> couple
> > of seconds.
> > USB completly locks up. First the mouse, then a bit later the file
> transfer
> > (so one was started) stops. Turning of the enclosure does not help,
> remving
> > the receiver and reinserting it, does not help, not using the hub
does
> not
> > help.
> > Only thing that brings back USB:
> > rmmod ehci_hcd
> > modprobe ehci-hcd
> >
> > rmmod and modprobe usb-storage does NOT help.
> >
> > after that I get another couple of seconds until it locks up again.
> >
> > If I modprobe ohci-hcd I get this:
> > with 2.6.26 and the mouse at ohci, enclosure at ehci, everything
works -
> but
> > gaming (with fglrx loaded) is impossible, since the mouse is
extremly
> jerky
> > (shared interrupts).
> > with 2.6.27 both mouse and enclose are driven by ohci - and copying
> works
> > without locking up. Trying to 'force' ehci for the enclosure makes
it
> lockup
> > again.
> >
> > This happens with kernel.org kernels+reiser4.
> 
> This chipset was known to have bugs in it, which I think we fixed
> already.  I have a laptop with this chipset and it can sustain large
> ammounts of USB data just fine with the 2.6.27 kernel series, so I
> wonder if something is wrong with your usb disk drive?
> 
> I've added some AMD developers on the CC: who helped develop the last
> fix for this chipset.  Libin, do you know of anything in the chipset
> that would cause these problems?
> 
> thanks,
> 
> greg k-h


