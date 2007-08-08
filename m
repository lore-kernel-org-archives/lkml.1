Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbXHHK4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbXHHK4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXHHK4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:56:15 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:57040 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751651AbXHHK4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:56:14 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Niels <zorglub_olsen@hotmail.com>
Subject: Re: Problems with USB disk
Date: Wed, 8 Aug 2007 13:57:03 +0300
User-Agent: KMail/1.9.7
References: <f9akh8$ori$1@sea.gmane.org> <20070807211847.GA25391@kroah.com> <f9c71t$r60$1@sea.gmane.org>
In-Reply-To: <f9c71t$r60$1@sea.gmane.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081357.03238.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 13:48:29 you wrote:
> On Tuesday 07 August 2007 23:18, Greg KH wrote:
> > On Tue, Aug 07, 2007 at 10:26:15PM +0200, Niels wrote:
> >> Hi,
> >>
> >> I'm having problems with a new 500 GB USB disk. It works, but sometimes
> >> I get these in dmesg:
> >>
> >>
> >> usb 1-3: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: USB disconnect, address 2
> >> drivers/usb/class/usblp.c: usblp0: removed
> >> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
> >>
> >> : ASC=0x4 ASCQ=0x2
> >>
> >> end_request: I/O error, dev sda, sector 254148215
> >> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
> >>
> >> : ASC=0x4 ASCQ=0x2
> >>
> >> end_request: I/O error, dev sda, sector 252434023
> >> EXT3-fs error (device sda1): ext3_find_entry: reading directory
> >> #15761836 offset 0
> >>
> >>
> >> There's also a printer connected. This is on a pci/usb2 card. When the
> >> above happens, I get I/O errors. When I mount the drive next, there are
> >> errors and often missing files. Quite annoying!
> >>
> >> Kernel is 2.6.21
> >>
> >> What's going on?
> >
> > You have a low voltage issue, or a bad cable.  The device is
> > electronically disconnecting itself.  Try using a externally-powered
> > hub, or a new cable.

I am seeing a similar problem with 2.6.22 and 2.6.23-* kernels with my 60G 
iPod Video, works fine with 2.6.18 kernel though.

Rehards,
ismail



-- 
Perfect is the enemy of good
